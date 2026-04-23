# 安裝指南

兩條路線，挑一條：

- **路徑 A**：手機 / claude.ai/code 使用者 → GitHub template，零指令
- **路徑 B**：桌面 App / 終端機使用者 → git clone + install.sh，一次裝到全域

## 你需要先有

- Claude Pro 或 Max 訂閱
- 路徑 A：GitHub 帳號（[沒帳號到這註冊](https://github.com/signup)）
- 路徑 B：[Claude 桌面版](https://claude.ai/download)（Mac 也可用 `brew install --cask claude-code`，其他平台看[官方指南](https://code.claude.com/docs/en/overview)）

## 路徑 A：GitHub Template（新手友善，零指令）

1. 開 https://github.com/fdjkgh580/claude-trip-skills
2. 點綠色的 **Use this template** → **Create a new repository**
3. 命名你的旅行專案（例如 `my-paris-trip`），建議選 **Private**，按 **Create**
4. 在 [claude.ai/code](https://claude.ai/code) 或手機 Claude app 的 code 標籤，指定剛建的 repo 開新對話
5. **先打個招呼**（例如「hi」）讓 Claude 載入專案。這步必要 — 第一次打 `/` 還掃不到 skills，要先送一次訊息 Claude 才會去讀專案
6. 接著打 `/trip`，開始規劃

> 💡 每趟旅行建一個新 template repo，旅行資料跟 skills 同 repo 但互不打架（skills 在 `.claude/skills/`，旅行檔在根目錄）。

### 升級 skills（之後想拉新版）

template 出來的 repo 不會自動跟原 repo 同步。想升級時：
1. 到原 repo 下載最新 `.claude/skills/` 整個資料夾
2. 蓋掉你 repo 裡的 `.claude/skills/`
3. commit & push

## 路徑 B：git clone + install.sh（桌面 / CLI，全域安裝）

```bash
git clone https://github.com/fdjkgh580/claude-trip-skills.git ~/Projects/claude-trip-skills
cd ~/Projects/claude-trip-skills
./scripts/install.sh
```

install.sh 會在 `~/.claude/skills/` 建立 symlink 連回 repo。**任何資料夾**打開 Claude Code 都能用 `/trip`。改 repo 內檔案會直接生效，不用重裝。

換電腦時重複上面 3 行就還原。

升級：
```bash
cd ~/Projects/claude-trip-skills && git pull
```

> Windows 使用者：本 repo 作者用 Mac，install.sh 未在 Windows 實測。請改用路徑 A，或自行在 PowerShell 對應 symlink 寫法。歡迎 PR 補 Windows 版。

## （選配）機票搜尋功能

想讓 Claude 幫你搜尋機票？在 Claude Code 裡貼上：

```bash
claude mcp add kiwi-com --transport http https://mcp.kiwi.com
```

沒裝也沒關係，Claude 會改用網路搜尋。

## 驗證安裝成功

打 `/trip` 應該看到旅行進度檢查回應。

**如果 `/` 沒看到 trip 開頭的指令**：
- 路徑 A 在 claude.ai/code：先送一句訊息再試（要先載入專案上下文）
- 路徑 B 在桌面 / CLI：確認你打開的資料夾不是 `~/.claude/skills/` 本身（要在另一個資料夾才看得到 user-invocable skills）
