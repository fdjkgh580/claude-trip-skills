#!/usr/bin/env bash
# 把 skills/ 底下的資料夾 symlink 到 ~/.claude/skills/
# 之後只要改 repo 內的檔案，~/.claude/skills/ 自動同步
# 遇到已存在的目標時會詢問是否覆寫

set -eo pipefail
shopt -s nullglob

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_HOME="$HOME/.claude"

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${BOLD}[INFO]${NC}  $1"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
skip()  { echo -e "${CYAN}[SKIP]${NC}  $1"; }

link_entry() {
  local src="$1"   # source file/dir
  local dst="$2"   # destination path under ~/.claude/

  # 已經指向本 repo，跳過
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    skip "${dst} (已連結)"
    return
  fi

  # 存在但不是本 repo 的 symlink，詢問覆寫
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    warn "${dst} 已存在"
    printf "       覆蓋? [y/N]: "
    read -r ans
    if [ "$ans" != "y" ] && [ "$ans" != "Y" ]; then
      skip "${dst}"
      return
    fi
    rm -rf "$dst"
  fi

  ln -s "$src" "$dst"
  ok "${dst} -> ${src}"
}

link_dir_contents() {
  local src_dir="$1"
  local dst_dir="$2"

  [ -d "$src_dir" ] || return
  mkdir -p "$dst_dir"

  local had_any=0
  for src in "$src_dir"/*; do
    [ -e "$src" ] || continue
    had_any=1
    link_entry "$src" "$dst_dir/$(basename "$src")"
  done

  if [ "$had_any" = "0" ]; then
    info "${src_dir} 為空，略過"
  fi
}

echo ""
echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD}  claude-trip-skills — install${NC}"
echo -e "${BOLD}========================================${NC}"
info "Source: $REPO_ROOT"
info "Target: $CLAUDE_HOME"
echo ""

info "處理 skills..."
link_dir_contents "$REPO_ROOT/skills" "$CLAUDE_HOME/skills"
echo ""

ok "完成"
