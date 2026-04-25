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

- **AskUserQuestion 選項在 CJK 語言（特別是繁體中文）出現「形似但錯字」**：
  - **現象**：使用者在 App / 雲端 Claude Code 跑 trip 系列 skill 時，AskUserQuestion 跳出的選項說明 / 題目文字常出現「看起來像中文但字錯了」的字。例如「**潮**你第一次去韓國」（應為「趁」）、「**豁規**複雜在最強複雜不太慌」（無意義字串）、「英**魅際**都難」（應為「英文都難」）。亂碼方塊不會出現，是 codepoint 錯但 decode 成另一個合法字
  - **使用者觀察**：terminal 環境出錯率明顯較低，App / 雲端版才會頻繁踩到。繁體中文是受害最嚴重的語言（5000+ 常用字、無組合冗餘）；英文幾乎不受影響；日文 Kanji / 韓文受中度影響
  - **規律**：Claude 從 SKILL.md **verbatim 複製** 的 label（短詞）幾乎不出錯；**自由生成**的 question / description / 比喻句最容易翻車
  - **推測根因**（未驗證）：
    1. App 環境的 model serving 跟 terminal 不同（不同變體 / 量化 / 採樣設定），CJK token 機率分佈漂移
    2. App stream 壓力下模型走較激進的採樣降低延遲，犧牲 CJK 精準度
    3. 不能完全在 skill 端解決，是底層 LLM + JSON tool call 的限制
  - **skill 端能做的緩解**：
    1. AskUserQuestion 選項 label 維持 1-3 字常見詞（現狀已是）
    2. SKILL.md 應該**也提供 question 句型範本**和 description 模板，讓 Claude 只填空，減少自由生成空間
    3. 在 skill 開頭加「AskUserQuestion 寫作紀律」段落，明示：description 用最簡單的 1 句、避免文言 / 比喻 / 雙關 / 罕字、必要時用 emoji 當視覺 anchor 讓使用者選錯時容易發現
    4. 紀律對所有語言都適用（不寫死中文限制），但 CJK 受惠最大
  - **下次修法時的對應檔案**：5 個 sub-skill 的 SKILL.md（trip-plan / trip-research / trip-go / trip-review / trip-pack），共通的 AskUserQuestion 紀律可放在 trip-plan SKILL.md 的「共通原則」段、其他 skill 引用

有需求？到 [Issues](https://github.com/fdjkgh580/claude-trip-skills/issues) 提一聲。
