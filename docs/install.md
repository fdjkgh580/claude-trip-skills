# 安裝指南

四種方式擇一，新手用方法一。

### 你需要先有

- Claude 桌面版（[下載](https://claude.ai/download)）或 [claude.ai](https://claude.ai)，切到 **Cowork** 或 **Code** 分頁
- Claude **Pro** 或 **Max** 訂閱
- 進階：終端機 CLI（Mac `brew install --cask claude-code`，其他平台看[官方指南](https://code.claude.com/docs/en/overview)）

> 💡 Windows 路徑對照（作者用 Mac，未實測，歡迎 PR 修正）：
>
> | Mac / Linux | Windows |
> |-------------|---------|
> | `~/.claude/skills/` | `%USERPROFILE%\.claude\skills\` |
> | 終端機 | PowerShell |
> | Finder | 檔案總管 |
> | `brew install` | 看官方安裝指南 |

### 方法一：在 Claude Code 裡貼一句話（推薦，不需技術背景）

把這句貼到對話框送出，Claude 會搞定下載與安裝。完成後建好旅行資料夾，打 `/trip` 開始。

> 幫我安裝這個旅行規劃技能包：https://github.com/fdjkgh580/claude-trip-skills

### 方法二：手動下載再匯入（不想讓 Claude 碰檔案系統時）

到 [GitHub 頁面](https://github.com/fdjkgh580/claude-trip-skills) → 綠色 **Code** 按鈕 → **Download ZIP**，解壓後跟 Claude Code 說：

> 我下載了旅行規劃技能包，解壓在「下載」資料夾裡的 claude-trip-skills-main，幫我安裝起來

### 方法三：一行指令安裝（工程師適用，僅 Mac / Linux）

```bash
git clone https://github.com/fdjkgh580/claude-trip-skills.git /tmp/claude-trip-skills && cp -r /tmp/claude-trip-skills/skills/trip-* ~/.claude/skills/ && rm -rf /tmp/claude-trip-skills
```

### 方法四：Clone + symlink（想自己改 skill 內容用，僅 Mac / Linux）

clone 後跑 install.sh 建立 symlink，改 repo 直接生效。換電腦時重跑這 3 行還原。

```bash
git clone https://github.com/fdjkgh580/claude-trip-skills.git ~/Projects/claude-trip-skills
cd ~/Projects/claude-trip-skills
./scripts/install.sh
```

### （選配）機票搜尋功能

想讓 Claude 搜尋機票，在 Claude Code 貼：

```bash
claude mcp add kiwi-com --transport http https://mcp.kiwi.com
```

沒裝也行，Claude 會改用網路搜尋給參考價格與訂票平台。

## 驗證安裝成功

輸入 `/trip` 應看到旅行進度檢查回應。若 `/` 後沒看到 `trip` 指令，先隨便打個招呼讓 Claude 載入上下文，再試一次。
