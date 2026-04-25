# 測試 Korea 規劃流程 — 問題記錄

**Branch**：`claude/test-korea-planning-VjR3j`
**開始日期**：2026-04-24
**目的**：模擬真實使用者從零開始規劃韓國行程，記錄過程中遇到的 skill bug、UX 問題、開發工具需求。最後挑必要修正合併回 main。

格式：每條一個 `## #N 標題`，含「現象 / 根因 / 候選修法 / 狀態」。

---

## #1 `/trip` 無法自動串接到 `/trip-plan`

**現象**
使用者在空工作區打 `/trip`，流程跑完 AskUserQuestion 選「好，開始」之後，Claude 想呼叫 `/trip-plan`，但 `Skill tool` 報錯：
> Skill trip-plan cannot be used with Skill tool due to disable-model-invocation

整條流程斷在這裡，使用者以為系統卡住。

**根因**
所有 `.claude/skills/trip-*/SKILL.md` frontmatter 都有：

```yaml
user-invocable: true
disable-model-invocation: true
```

但 `/trip` SKILL.md 的 Step 6 寫：
> 使用者選了「好」之後 — 直接呼叫對應的 skill。不要再問一次「確定嗎」。

兩邊衝突。`/trip` 承諾會自動接下去，但底層設定禁止 Claude 主動觸發。

**候選修法**

| 方案 | 說明 | 風險 |
|---|---|---|
| A. 拿掉 `disable-model-invocation: true` | 讓 trip-plan / trip-research / trip-go / trip-review / trip-pack / backup 可被 Claude 串接 | 使用者閒聊「想去日本」時可能被誤觸發。需把各 skill 的 `description` 寫得更嚴格（明確列觸發詞） |
| B. 改 `/trip` SKILL.md 措辭 | 使用者選「好」後，改成顯示「好，請打 `/trip-plan` 繼續」，讓使用者手動再打一次 | 多一步點擊，但零風險 |
| C. 混合 | 保留 disable，但在 `/trip` 回應尾端顯示明顯的「下一步：打 `/trip-plan`」提示 | 介於 A / B 之間 |

**建議方向**：A。理由：
- trip 系列是嚴格流程鏈（plan → research → go → review → pack），鏈條語意本來就要自動串接
- `/trip` 的進入條件已經很明確（有 trip folder 或使用者明說要規劃）
- 各 skill 的 description 寫精準一點就能控制誤觸發

**狀態**：未修。等整趟測試跑完再一起決定。

**暫時 workaround**：使用者手動打 `/trip-plan`。

---

## #2 `/trip` 對使用者洩漏技術術語 + 內部檢查過程

**現象**（使用者手機截圖）
`/trip` 在判斷「空工作區」的過程中，畫面出現這些對一般使用者完全沒意義的文字：

- 「`current-trip` 不存在、也沒有任何行程資料夾」
- 「我確認一下 `CLAUDE.md` 的 `TRIP_METADATA_START` 是不是舊版殘留資料，還是只是文件裡提到的字串」
- 「只是文件說明字串，不是實際殘留資料。這是乾淨的工作區」

外行人看到 `current-trip`、`CLAUDE.md`、`TRIP_METADATA_START`、「殘留資料」、「乾淨的工作區」這些詞只會一頭霧水，不知道 Claude 在幹嘛。

**根因**（兩層）

1. **檢查邏輯太粗**：`/trip` SKILL.md 教 Claude 用 `grep TRIP_METADATA_START CLAUDE.md` 偵測舊版殘留，但 CLAUDE.md 本身就**提到**這個 marker 當作文件說明（`<!-- TRIP_METADATA_START -->`），導致誤判為「舊版殘留」。為了釐清，Claude 不得不再跑第二次 grep 秀上下文，並在過程中把兩次檢查都講給使用者聽。
2. **narration 洩漏**：Claude 把「我在做什麼技術檢查」直接講出來。CLAUDE.md 的「措辭硬規則」禁止對使用者用 git 術語，但**沒有**明文禁止講 skill 內部檢查邏輯、指標檔名、marker 名。實際上這類訊息對規劃使用者完全沒用，應該靜默處理。

**候選修法**

| 方案 | 說明 |
|---|---|
| A. 收緊 legacy 偵測 | SKILL.md 改成用 `grep -q '<!-- TRIP_METADATA_START -->' CLAUDE.md` 偵測（精確找 HTML 註解 marker），而不是找字串。這樣不會跟文件裡的提及互相撞名，不用二次檢查 |
| B. SKILL.md 加 narration 規則 | 明文寫：內部檢查（判斷是不是舊版殘留、指標檔在不在、trip folder 列表…）**靜默執行，不要講給使用者聽**。只在結果需要使用者行動時（例如真的有舊版殘留要搬遷）才開口。對規劃使用者**禁止提到** `current-trip`、`CLAUDE.md`、`TRIP_METADATA_START`、「指標檔」、「marker」、「殘留資料」這類詞 |
| C. 擴充「措辭硬規則」禁用表 | CLAUDE.md 的禁用術語表目前只蓋 git。要補上 skill 內部概念（指標檔 / marker / 殘留 / 工作區 / current-trip / CLAUDE.md）|

**建議**：A + B + C 都做。A 解決誤判根因，B + C 解決 narration 洩漏。兩者缺一會繼續漏。

**狀態**：未修。

**重要澄清（使用者提問）**：「這是不是因為我是開發者你才顯示給我看？」
**答**：不是。Claude 對所有使用者 narration 一致。CLAUDE.md 明文禁止依「路徑看起來像程式碼專案 / 有 `.claude/skills` / 有 `scripts/`」切換語氣，規則反而是「信任使用者，99% 不是工程師」。所以一個完全外行的使用者在這個 repo 打 `/trip`，**會看到一模一樣的技術洩漏**。這代表問題 100% 可重現，不是 edge case。

---

## #3 Stop hook「未儲存」提醒頻率過高，在對話中段就嘮叨

**現象**
跑 `/trip-plan` 建完行程資料夾、問使用者「什麼時候出發 / 幾天 / 預算」這三題後，Claude 暫停等使用者回答。此時 Stop hook 觸發，Claude 下一輪就跳出「💾 目前還有變更尚未儲存…」提醒。但**使用者還在思考第一題的答案**，根本還沒做完要儲存的階段。

接下來使用者回答完基本資訊、Claude 接著寫 trip-meta.md、traveler-profile.md…每一次問完問題等回答，Stop hook 都會再觸發一次提醒。整個 `/trip-plan` 從頭跑完預估會被提醒 5-8 次。

**根因**
Stop hook 的觸發條件是「assistant 回合結束 + 有未提交檔案」。但 skill 設計把整個 `/trip-plan` 流程拆成多個 AskUserQuestion / 開放式問答回合，**每個回合都是一個 stop 點**。CLAUDE.md 規則寫「每輪只講一次」是指**單一 response 內不重複**，不是「整個 session 只講一次」，所以 Claude 照規則每輪都提醒。

規則本身沒錯（使用者 idle 久了關視窗會失去資料）。問題是「一個 skill 的完整執行」現在橫跨多個 stop 點，每個 stop 點都提醒 = 嘮叨。

**候選修法**

| 方案 | 說明 | 代價 |
|---|---|---|
| A. Stop hook 只在「使用者最後一輪對話後 N 分鐘 idle」才提醒 | 加 debounce，idle 才提醒，對話進行中靜默 | 需要追蹤時間戳，hook 邏輯複雜化 |
| B. CLAUDE.md 規則改成「整個 skill 執行過程中只提醒 1 次」 | 用某種 flag 追蹤本 session 已提醒過 | Claude 要記 flag，但跨輪記憶不穩定 |
| C. Stop hook 判斷「當前是否在 skill 執行中」 | 若是，跳過提醒；skill 結束才提醒 | 需要 skill 在開始/結束時寫狀態檔 |
| D. 提醒訊息簡化 | 第二次起改成一行極短「💾 尚未儲存」不含完整三個觸發詞範本 | 比較不擾人但規則明文要「完整列出」|

**建議**：A + D。A 解決根因（使用者活躍中就別吵），D 當 fallback（萬一還是提醒了至少短）。C 也可以但需要改多處。

**狀態**：未修。正在跑 `/trip-plan` 的測試過程中第二次被提醒，先記下。

---

## #4 `/trip-plan` 中段重新觸發會回到 0.5b 問「你要怎麼做」，但沒處理「in-flight 有未寫入資料」的狀態

**現象**
跑 `/trip-plan` 到一半（問完兩輪畫像 AskUserQuestion、進到 step 3 開放式問「有什麼一定要做的事」等待使用者回答時），使用者再打一次 `/trip-plan`。

按 skill 設計：
1. step 0.5 偵測到 `current-trip` + `1-韓國-2026-04-24/` 存在 → 走 0.5b
2. 0.5b 彈 AskUserQuestion 問「目前指向 **1-韓國-2026-04-24**，你想怎麼做？」選項：修改這個行程 / 切換 / 建立新行程

但此時：
- `trip-meta.md` **還沒寫入**（step 5 才寫）
- `traveler-profile.md` **還沒寫入**（step 6 才寫）
- 前面兩輪 AskUserQuestion 的答案都只在對話 context 裡

若使用者選「修改這個行程的設定 / 畫像」（0.5b 的推薦選項），按 skill 設計會跳到 step 2。但 step 2 預期讀 `traveler-profile.md` 得到現有畫像 → **檔案不存在**，只好又進「畫像建立流程」從頭問 — **整個兩輪 AskUserQuestion 重來**。

**根因**
Skill 的狀態判斷只看「檔案是否存在」，沒區分兩種狀態：
- 真的修改一個**已完成規劃**的舊行程（trip-meta + profile 都寫好了）
- **規劃中途被重新觸發**（檔案還沒寫入，資料在對話 context）

兩者該走完全不同的路徑。

**候選修法**

| 方案 | 說明 |
|---|---|
| A. 寫一個 `.trip-plan-in-progress` flag 檔 | step 0.5 開始時建 flag，step 6 結束時刪除。偵測到 flag 還在 → 告訴使用者「你剛剛在中途離開，要繼續還是從頭重來？」 |
| B. 每輪 AskUserQuestion 之後就即時 flush 一次 trip-meta.md / traveler-profile.md | 檔案永遠反映最新收集到的資料。即使中斷也能從檔案恢復 |
| C. `/trip-plan` 開頭檢查「已有 trip folder 但 trip-meta.md 不存在」 → 判為「上一次規劃中斷」，用專用提示 | 不用新增 flag 檔，用既有檔案狀態推斷 |

**建議**：C 最省事（利用既有條件，不需新增狀態檔）。B 其次（讓資料更有韌性）。A 最保險但最囉嗦。

**狀態**：未修。本次測試中主動要求使用者看到 0.5b 的對話，讓使用者自行決定要重問還是就地完成。

---

## #5 `traveler-profile.md` 模板欄位與實際問答流程不一致（多處）

**現象**
`/trip-plan` step 6 要求寫入的 `traveler-profile.md` 模板包含以下欄位：

- 國籍
- 姓名（中文）
- 姓名（護照英文）
- 緊急聯絡人
- 同行兒童年齡
- 護照狀態

但 step 2 的「畫像建立流程」**完全沒有對應的 AskUserQuestion 或開放式問題**來收集這些。結果 profile 寫出來一堆「（未填）」，使用者打開檔案會覺得「我什麼都沒做，這些是怎麼出現的？」

同時，模板還混了**本趟行程專屬**的欄位（不該放在「所有行程共用」的 profile）：

- 旅伴 → 每趟不一樣
- 預算等級 → 每趟不一樣（獨旅 vs 蜜月預算差很多）
- 住宿等級 / 住宿類型 → 每趟不一樣
- 核心興趣 → 每趟可能不一樣（文化之旅 vs 美食之旅）
- 研究深度、行程輸出格式 → 純協作設定，屬於 trip-meta 不屬於 profile

**根因**
SKILL.md 對「共用 profile vs 本趟 trip-meta」的欄位歸屬劃分不夠清楚。既有 docs 說「profile 跨行程共用」但模板把 trip-specific 欄位也塞進去。且 skill 問答流程跟模板欄位對不上（skill 沒問國籍 / 姓名 / 緊急聯絡人 / 護照狀態等，但模板要求）。

**候選修法**

| 方案 | 說明 |
|---|---|
| A. 把 trip-specific 欄位從 profile 搬到 trip-meta | profile 只保留「人的屬性」：國籍、姓名、緊急聯絡人、飲食、體力、語言能力、旅行經驗、護照狀態、同行兒童年齡。trip-meta 裝「這趟的」：旅伴、預算、住宿、核心興趣、排除項、協作設定 |
| B. skill step 2 增補問答 | 加一輪問國籍、中英文姓名、緊急聯絡人、護照狀態（這些是 trip-research 跟 trip-pack 需要的） |
| C. 把「（未填）」改成「使用者尚未提供」並在 profile 檔頭加一行 note：「這些欄位 `/trip-pack` 會需要，之後再補」| 先不改流程，降低使用者困惑 |

**建議**：A + B 都做。A 修模板結構（共用 / 專屬職責清晰），B 補流程（skill 有問才寫）。C 當短期補丁。

**狀態**：未修。本次測試寫出來的 profile 有 4 個欄位標「（未填）」。

---

## #6 `/trip-research` 的 5 個 agent 一次性派出會撞 App 端 5 分鐘 stream idle timeout

**現象**
使用者答完 `/trip-research` 第一階段 AskUserQuestion（國籍 / 護照 / 優先主題）後，Claude 試著按 SKILL.md 步驟一次做完：
1. 寫入 profile 的國籍+護照
2. 派 gate agent
3. 寫 research-checklist.md
4. 派 5 個深度研究 agent 的長 prompt

這 4 件事在一個 assistant response 內完成需要很久生成文字。**過程中沒有任何 text output 噴出去**，App 端 5 分鐘 stream idle timeout 觸發 → 使用者看到 `Request timed out`、請求失敗、沒有任何 agent 被派出。

使用者直接質問：「目前進度如何啊？怎麼都沒有顯示進度呢？如果長時間跑的話，應該放到背景吧？」— 這三個問題都是使用者經驗真實的痛點。

**根因**（兩層）

1. **`/trip-research` SKILL.md 沒明說「分輪次輸出進度」**：Skill 的第一至第五階段流程寫得像「一氣呵成」，沒有明確指示「每個 agent 派出都要先講一句話」「每寫一個檔案都要先講一句話」。Claude 讀到後容易把它當成一個大回合來跑。
2. **CLAUDE.md 的「環境感知 — 分批寫入 + 頻繁進度回報」規則**雖然有講這件事，**但沒明列到 `/trip-research`、`/trip-go`、`/trip-pack` 這三個「派 agent / 大量寫檔」的 skill 裡**。Claude 執行 skill 時主要看 SKILL.md，CLAUDE.md 的通用規則容易被忽略。

**候選修法**

| 方案 | 說明 |
|---|---|
| A. 在 `/trip-research` SKILL.md 顯式加一段「執行紀律」 | 寫死：「每派一個 agent 之前先輸出一句話說明正在派誰」「每寫一個檔案之前先輸出一句話」。強制拆成多個 tool call 之間都有 text，避免 5 分鐘靜默 |
| B. SKILL.md 加一個 **App 環境專用** 章節 | 「若偵測不到環境，預設 App 模式；agent 一律 `run_in_background: true`、每個動作分批做」|
| C. 在 `/trip-go`、`/trip-pack` 等所有大型 skill 都複製 A 的段落 | 不只 research 有這問題，go / pack 也會（都是大量寫檔+派 agent）|
| D. 改成「先派 1-2 個主要 agent + 立刻告訴使用者有在背景跑 + 後續 agent 等第一輪結果再決定要不要派」 | 串行化減少單一回合負擔。但會拖長總時間 |

**建議**：A + B + C 都做（統一規則 + 每個 skill 都明列）。D 不建議（違反「平行快速拿到結果」的核心價值）。

**狀態**：未修。本次測試正在現場示範此 bug（已 timeout 一次），接下來重試會用「每個動作噴一句話」的新做法。

---

## #7 `/trip-research` 派 agent 時使用者看不到進度（即使成功，中間沒文字也像當機）

**現象**（與 #6 相關但分開記）
即使派 agent 技術上成功（`run_in_background: true`），使用者在 App 上**看不到任何 tool call 細節**，只看得到 Claude 的文字輸出。如果 Claude 派完 agent 就靜默等待，使用者會問：

- 「現在在幹嘛？」
- 「有在跑嗎？還是當機了？」
- 「我要關掉 App 了嗎？」

這次測試裡使用者的原話：「目前進度如何啊？怎麼都沒有顯示進度呢？」

**根因**
SKILL.md 沒規定「背景 agent 派出後要給使用者什麼中間回饋」。假設 agent 跑 10-15 分鐘，中間這段時間 Claude 應該：

- 告訴使用者每個 agent 的主題與預估完成時間
- agent 回來時一個一個回報（不要等全部回來才講）
- 使用者若主動問「還在嗎」要回「在，A agent 3 分鐘前回報、B 還在跑」這類具體狀態

**候選修法**

| 方案 | 說明 |
|---|---|
| A. SKILL.md 加「派 agent 時的使用者介面腳本」 | 「派 agent 後立刻輸出：『我派了 5 個 agent 到背景，預計 10-15 分鐘完成。你可以現在去做別的，或在這邊等，任何時間問我『進度』都會告訴你目前狀態』」 |
| B. 用 TodoWrite 呈現每個 agent 的狀態 | 把 5 個 agent 各做一個 todo 項，`in_progress` → `completed`，使用者在 App UI 看得到勾選變化 |
| C. Monitor/poll agent 回報時主動發一句「A agent 回來了，正在看報告」 | 每個 agent 完成都嵌一句 text 更新 |

**建議**：A + B + C 三管齊下。A 讓使用者一開始就知道遊戲規則，B 讓 UI 有視覺進度，C 讓中間有文字心跳。

**狀態**：未修。下一輪會試著示範 A + B + C 的實作效果。

---

## #8 多個並行 agent 一起跑會撞到使用者帳號的 usage limit，且部分 agent 失敗時 skill 沒回收機制

**現象**
本次測試派出 6 個 agent 平行跑（gate + R1-R5），全部回傳結果都是 `You've hit your limit · resets 9:20pm (UTC)`：

| Agent | 工具呼叫次數 | 實際產出 |
|---|---|---|
| gate | 18 | 14KB（多數 OK，2 TODO 未完）|
| R1 | 23 | 7.7KB（4 TODO 未完）|
| R2 | 14 | 9.7KB（9 TODO 未完）|
| R3 | 7 | 4.9KB（只完成 C1，C2/C3/C4 全 TODO）|
| R4 | 8 | 771 bytes（14 個 H2 全 TODO，等於沒研究）|
| R5 | 0 | **檔案不存在**（連骨架都沒寫到） |

R5 完全沒檔，代表那個 agent 連 step 1（先寫骨架）都沒跑就被 limit 擋下。其他 agent 跑到一半也被擋。

**根因**

1. **平行派 agent 會疊加 token 消耗**：5 個 agent + 1 gate 同時在後台搜尋 / WebFetch，token rate 集中爆炸。使用者帳號 / 訂閱方案的 limit 撐不住，全部被 throttle。
2. **Skill 沒有 limit 防呆 / 回收策略**：當 agent 回報 limit 錯誤時，主 Claude 應該偵測到「這份報告全是 TODO」並提示使用者「研究失敗，需要重派」。目前 skill 沒這個檢查邏輯，使用者不知道 R4 / R5 其實沒做。
3. **失敗的 agent 重派沒有腳本化**：要重派 R3/R4/R5/R6 必須等 limit 重置（~20 小時），且 SKILL.md 沒寫「半途失敗時怎麼接續」的流程。

**候選修法**

| 方案 | 說明 |
|---|---|
| A. SKILL.md 加「派 agent 後檢查報告完整度」段落 | 等所有 agent 回報後，主 Claude 用 grep TODO 計算每份報告的完成度。完成度 < 70% 的標為「需重派」並列出來給使用者選擇怎麼處理 |
| B. 提供「失敗回收」mode | 偵測到 limit 錯誤時自動降階：把多個失敗 agent 合併成 1 個簡化 agent 重派（搜尋上限砍半，只取 must-have），而不是逐一重派 |
| C. 派 agent 前估算 token 預算 | 5 個並行 × 25 次搜尋 × 平均 2-3KB / 次 = ~300-500KB token usage，超過 limit 警示閾值就降到 3 個並行（rolling 派）|
| D. 提供「斷點續派」指令 | `/trip-research --resume` 會掃 research/ 目錄、找出哪些 agent 報告不完整，只重派這些，不從頭開始 |

**建議**：A 是必做（不檢查就不知失敗）。B 和 D 是進階。C 屬於資源規劃，需要更多資料才能調得準。

**狀態**：未修。本次測試 R3/R4/R5/R6 全部得手動補做或等 limit reset 重派。

---

## #9 Skill 用「固定 agent 數量」（標準 2 個 / 深度 5 個）是錯的，應該按工作量動態決定

**現象（使用者原話）**
> 每個不同的 Agent 如果執行的事情比較少等候期就會比較少吧，所以這樣反而是依照我們的數量跟複雜度自動去評估要分派的數量對嗎？

使用者一語點破：當前 SKILL.md 寫死「標準 = 2 個 agent / 深度 = 5 個 agent」，但實際 agent 工作量（要查的清單項數）跟使用者興趣多寡、目的地複雜度、是否含轉機 / 住宿研究等都有關。

舉例：
- 「使用者只選 1 個興趣 + 沒住宿 + 直飛」→ 2 個 agent 已經夠，不用 5 個
- 「使用者 7 個興趣全選 + 含轉機 + 多城市 + 特殊需求（例如本次的女生彩妝獨立 R5）」→ 5 個 agent 都不夠細，需要 6-7 個

固定數量導致：
- 工作量小卻派 5 個 agent → 浪費 token
- 工作量大卻只派 5 個 → agent 內部要處理太多項，容易塞太擠 / 被 limit 擋（見 #8）

**根因**
SKILL.md 第三階段「Research Agent 策略」表格用「研究深度」做 agent 數量決定，但研究深度和**實際工作量**是兩回事。深度應該決定「每項挖多深」，工作量應該決定「拆幾個 agent」。

**候選修法**

| 方案 | 說明 |
|---|---|
| A. 用研究清單項數動態算 agent 數 | 跑完 research-checklist.md 後，計算總工作量（總項數 × 興趣權重）。每個 agent 負責 5-7 個清單項為宜，總 agent 數 = ceil(項數 / 6) |
| B. 維持兩個 mode 但改名稱 | 「快速 = 2 個」「徹底 = 動態」。徹底版根據清單算實際 agent 數 |
| C. 加一道「使用者可調」的閾值 | 使用者可指定「最多派 N 個 agent」上限，避免 limit 爆掉 |

**建議**：A + C。A 解決根因（依工作量），C 給使用者煞車（避免 token 爆掉）。

額外原則：**特殊使用者需求應自動觸發專屬 agent**。例如本次使用者特別強調「女生彩妝保養品」，這應該被 skill 自動識別為「值得獨立 agent 的子主題」，而不是塞進 R1（核心體驗）一起做。需要建一個「興趣權重 → 專屬 agent」的 mapping。

**狀態**：未修。本次測試的「動態派 agent」是手動做的（我看清單後決定 R5 獨立給購物用），但 SKILL.md 沒明說可以這樣做，靠 Claude 臨場判斷不可靠。
