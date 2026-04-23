# 在哪些環境可以使用？

不同環境支援度不同，先看表：

| 環境 | 怎麼用 trip skills | 備註 |
|------|------|------|
| 桌面 App（Mac / Windows） | 路徑 B 裝到 `~/.claude/skills/` | 全域可用，所有專案通用 |
| 終端機 CLI | 路徑 B 裝到 `~/.claude/skills/` | 全域可用 |
| VS Code / JetBrains 擴充 | 路徑 B 裝到 `~/.claude/skills/` | 全域可用 |
| **claude.ai/code（網頁版）** | 路徑 A 用 GitHub template 建專案 repo | 雲端環境，碰不到 `~/.claude/`，只能讀 repo 內 `.claude/skills/` |
| **手機 Claude app（iOS / Android）** | 路徑 A 用 GitHub template，在 code 標籤打開 | 跟 claude.ai/code 同原理 |
| claude.ai 一般對話（手機或網頁） | 透過 Settings → Customize 上傳 skills | 跟 Claude Code 是兩條獨立對話，無法讀寫專案檔 |

兩條安裝路徑詳見 [安裝指南](install.md)。

## 為什麼 claude.ai/code 與手機 app 要走 GitHub template？

claude.ai/code 與手機 Claude app 的 code 標籤都是 Anthropic 雲端代管環境，跑在遠端虛擬機上，**碰不到你電腦的 `~/.claude/`**。它只能讀你打開的那個 GitHub repo 內的 `.claude/skills/`。

GitHub template 解法把 trip skills 跟旅行專案打包在同一個 repo，雲端打開就能用。

## 重要：載入時機（已實測）

在 claude.ai/code 或手機 Claude app 第一次打開專案時，**輸入 `/` 不會出現 trip 指令的自動完成提示**。

原因：當你從下拉選單選了專案，Claude 還沒真的去讀那個專案 — 要等你送出第一則訊息，Claude 才會載入專案上下文並掃到 `.claude/skills/`。

**做法**：先打個招呼（例如「hi」），送出。第二次再打 `/`，就會看到 `/trip`、`/trip-plan` 等指令的自動完成。

## 規劃文件想在手機看？

→ 看 [手機用法](mobile.md)。簡短答案：要在手機**看完整規劃並編輯**，就用 GitHub template 路線，本身就具備同步能力（commit & pull）。Notion / iCloud 不適合規劃工作流（無法雙向同步、無法被 Claude 讀寫）。
