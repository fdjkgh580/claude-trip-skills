# Roadmap（之後版本想做的）

以下是評估後暫緩、之後可能納入的功能。歡迎在 Issue 提出使用情境或需求，幫助判斷優先級：

- **匯出能力**：把行程表匯出為 `.ics`（行事曆檔）、`.csv`（試算表）、`.kml`（Google Maps 釘點）、PDF（分享給不用 Claude 的朋友）
- **跨旅行畫像繼承**：一年跑多趟旅行的人可以從上次專案複製畫像，不用重填
- **時效性標記強制化**：票價、營業時間、特展等會變動的資訊，超過一段時間自動標「請出發前再次確認」
- **多人分帳計算**：記帳檔升級為誰付 / 誰欠誰的分帳，不離開 Claude 就完成 Splitwise 類功能

## 待追蹤問題（Known Issues / 開發中持續追蹤）

- **手機 / 雲端 Claude Code 的 Stream idle timeout（5 分鐘）**：
  - **現象**：Claude 執行長時間任務（連續寫多個大檔、跑多個 agent）時，若 stream 超過 5 分鐘沒有新 token 就會斷線，顯示「API Error: Stream idle timeout - partial response received」
  - **官方狀態**：目前**沒有公開的修復或推薦解法**，GitHub 有 issue 追蹤中（https://github.com/anthropics/claude-code/issues/47841）
  - **暫時解法**：
    1. 在 `~/.claude/settings.json` 的 `env` 區塊設 `CLAUDE_STREAM_IDLE_TIMEOUT_MS`（毫秒）調高 idle timeout，例如 `3600000`（60 分鐘）。**此環境變數沒有官方擔保、手機環境不保證生效**，要重開 session 才讀進去
    2. 大檔案改用「先 Write 骨架、再多次 Edit 追加」的分批策略，每次 token 回饋會重置 idle 計時器
  - **未來 skill 改版時可考慮**：在 skill 指引裡讓 Claude 主動把大塊輸出拆成多次 Edit（trip-research agent prompt 已有類似的「寫骨架 → flush」紀律，可推廣到其他 skills）

有需求？到 [Issues](https://github.com/fdjkgh580/claude-trip-skills/issues) 提一聲。
