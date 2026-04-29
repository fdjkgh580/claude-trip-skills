# Claude Trip Skills 工作區

這個資料夾安裝了 trip 規劃技能（`.claude/skills/trip-*`）。它有兩種合法用途：

1. **直接規劃旅行**（最常見）— 打 `/trip` 開始
2. **修改 / 開發 trip skills 本身** — 編輯 `.claude/skills/trip-*/SKILL.md`、`scripts/install.sh` 或其他原始碼

**一個倉庫可以存放多個不同行程**。詳見下方「多行程工作區 — 指標檔與資料夾規則」。

## 給 Claude 的執行規則

當使用者在這個資料夾打 `/trip`、`/trip-plan` 等 trip 系列指令：

- **不要警告「這個資料夾看起來是程式碼專案，不適合放旅行檔案」**。`README.md` / `scripts/` / `docs/` / `.git/` 的存在屬於合理結構，trip 規劃檔（編號行程資料夾、`traveler-profile.md`、`current-trip` 等）會跟它們和平共存。
- 這個資料夾**就是** trip 規劃工作區，請直接執行 skill 流程，**不要詢問「真的要在這裡規劃嗎？」**
- 99% 以上的使用者不是工程師，這類「環境位置不適合」的提醒看不懂、只會勸退他們。預設信任使用者在這裡規劃就是對的。

## 多行程工作區 — 指標檔與資料夾規則

一個倉庫一次可以放多個獨立行程。每個行程是**一個獨立資料夾**，命名格式：

```
{編號}-{地點}-{YYYY-MM-DD}
```

例子：

```
./1-布達佩斯-2026-04-24/
./2-日本-2026-04-24/
./3-冰島-2026-10-03/
```

- **編號**：從 1 開始，依建立順序累加（下一個 = 現有最大編號 + 1）
- **地點**：使用者怎麼稱呼就怎麼填（城市、國家、區域皆可，不強迫指定國家；例如「布達佩斯」「日本」「北歐」都 OK）
- **YYYY-MM-DD**：**開始研究的日期**（建立資料夾當天的系統日期，用 `Bash date +%Y-%m-%d` 抓，**不是**旅程日期）。因此相同地點可依研究時間點自然區分（10 月規劃的日本 vs 明年 2 月規劃的日本）

### 指標檔 `current-trip`

根目錄的 `current-trip` 是純文字檔，內容寫著「目前在規劃哪一個行程」的完整資料夾名，例如：

```
1-布達佩斯-2026-04-24
```

**所有 trip 系列 skill 在開始工作前都必須：**

1. 用 Read 讀 `./current-trip` 取得當前行程資料夾名（trim 空白/換行）
2. **在回應最開頭顯示一行**「📍 目前在規劃 **{資料夾名}**」讓使用者隨時知道自己在改哪個行程
3. 之後所有檔案 read / write 都對著 `./{資料夾名}/...` 操作，**不要寫到根目錄**（除了根目錄共用檔）

### 指標檔不存在 / 指向無效資料夾時

若 `./current-trip` 不存在、內容為空、或指向的資料夾不存在（例如使用者手動刪了），請：

1. 用 `Bash ls -1d [0-9]*-*-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ 2>/dev/null` 掃現有行程資料夾
2. **有現有行程** → 用 `AskUserQuestion` 列出來讓使用者選要繼續哪一個（額外加一個「開始規劃新行程」選項）。選完後把結果寫回 `./current-trip`
3. **完全沒有行程** → 告訴使用者「這個資料夾還沒有任何行程」，引導打 `/trip-plan` 建立第一個

### 共用 vs 行程專屬

**根目錄共用**（所有行程通用）：
- `traveler-profile.md` — 旅行者畫像（人是同一個，不用每趟重填）
- `current-trip` — 指標檔
- `CLAUDE.md` — skill 規則（本檔）

**每個行程資料夾內專屬**（在 `{編號}-{地點}-{YYYY-MM-DD}/` 底下）：
- `trip-meta.md` — 這趟行程的 metadata（目的地、日期、狀態、風格、協作設定）
- `research/` — 研究報告
- `flights/`、`lodging/`、`insurance/` — 訂單類
- `final-itinerary.md` 或 `overview.md` + `day-*.md` — 行程表
- `review.md` — 審查報告
- `checklist.md` — 行前清單
- `expense-log.md` — 記帳檔
- `emergency-card.md`、`photography-guide.md` 等衍生檔案

## 儲存到雲端的規則

雲端 Claude Code（claude.ai/code、手機 Claude app code 標籤）是**短暫的 sandbox**，使用者修改的檔案不會自動存到 GitHub。session 結束未儲存的變更會消失。

### 收到「未儲存」系統訊息時

如果 Stop hook 注入了「⚠️ 偵測到未儲存的變更」這類系統訊息，**請在你下一輪回應的開頭或結尾**主動提醒使用者，**且必須完整列出三種自然語言觸發詞 + 斜線指令**（不要只挑一種講、不要省略自然語言）：

> 💾 目前還有變更尚未儲存，跟我說「儲存」「save」「備份」其中一個，或打 `/backup`，就會把變更存到雲端。不然關掉視窗會不見。

理由：99% 使用者不會記得 slash command，自然語言是主要觸發方式，必須優先呈現。

不要等使用者問，主動講。但**每輪只講一次**（不要重複嘮叨）。

### 強制使用 /backup：禁止手動跑 git 寫入操作

**任何**需要 commit / push / merge / checkout / branch 切換的時刻，**一律呼叫 `/backup` skill**，**絕對禁止**自己跑這些指令。

觸發 /backup 的所有情境：

- ✅ **只有當使用者明確說**「儲存」「保存」「存到雲端」「commit」「存起來」「備份」「上傳」「會不會不見」這類詞 → 呼叫 /backup
- ✅ Stop hook 提醒「尚未儲存」後，使用者**下一輪明確同意儲存** → 呼叫 /backup

**禁止主動呼叫的情境**（會煩到使用者）：
- ❌ Claude 自己寫完檔後**不要主動跳出來問**「要存嗎」。讓 Stop hook 去做被動提醒就好
- ❌ trip 系列 skill 跑完後**不要自動接著跑 backup**。寫完檔就停，等使用者決定要不要存
- ❌ 對話結束前**不要**「我幫你順便存一下」這種行為
- ❌ 看到 git status 有 uncommitted changes **不要**主動跳出來救。Stop hook 會處理提醒

核心原則：**被動提醒 + 使用者主動決定**。Claude 不要當熱心過頭的助理。

**禁止使用的指令**（會改動 repo 狀態的全禁）：
- `git commit`、`git add`
- `git push`
- `git merge`
- `git checkout <branch>`、`git switch <branch>`
- `git branch <new>`、`git branch -d`
- `git stash`、`git rebase`

**唯一允許自己跑**：純讀取的 git 指令（不改狀態）：
- `git status`
- `git log`
- `git diff`
- `git rev-parse --abbrev-ref HEAD`（看當前 branch 名）

理由：/backup 內部負責完整流程（commit → 推 feature branch → 切 main → merge → 推 main → 刪 feature branch → 留在 main）。手動跑 git 會繞過這個流程，導致資料卡在 feature branch、main 永遠空，使用者下次找不到。

**觸發方式**：使用者**明確說**「儲存」「備份」這類詞，**或**使用者主動打 `/backup`。Claude 不要在沒被要求的時刻主動觸發。

### 使用者問起 git/branch 概念時

如果使用者主動問「我在哪個 branch」「為什麼有 claude/xxx 那串東西」「main 怎麼沒更新」之類問題：

1. **不要直接秀技術 branch 名**（例如 `claude/create-helloworld-md-WsjrB`）
2. 用最白話回答：「目前在工作版本，沒整理到主線」
3. **主動呼叫 /backup**：「我幫你整理一下，整理完就只剩主線一個版本，乾乾淨淨」
4. /backup 跑完後，使用者就停在 main，下次也不會再看到 branch 名

**唯一例外**：如果使用者用了「branch」「checkout」「merge」這類詞並表現出懂 git，可以正常用術語回答。但仍要主動 invoke /backup 處理 merge 到 main。

### 措辭硬規則

對 trip 規劃使用者**禁用以下術語**（即使使用者自己用，你回覆時也只用簡單詞）：

| 禁用 | 改用 |
|---|---|
| commit / commit message | 儲存 |
| push / pull / fetch | 存到雲端 / 從雲端拿 |
| merge / rebase | 合併 / 整合 |
| branch / checkout | （盡量不要提分支概念）|
| stash / staging / HEAD / origin | （盡量不要出現） |
| repo / repository | 旅行專案 / 資料夾 |
| current-trip / 指標檔 / marker / TRIP_METADATA_START / 殘留資料 / 乾淨的工作區 / 舊版格式 | （這些是 skill 內部概念，對使用者靜默處理，不要講）|
| 檔名如 `trip-meta.md` / `CLAUDE.md` / `research/` | 用白話替代：「行程設定」「說明檔」「研究報告」 |

99% 使用者不是工程師。看到 git 術語或 skill 內部詞會立刻迷失。

## 內部檢查必須靜默執行

Trip 系列 skill 執行前會做很多**內部狀態檢查**（指標檔存在與否、舊版殘留偵測、研究清單完成度估算、trip-meta.md 有沒有、哪個 agent 還沒回…）。這些檢查對規劃使用者完全沒意義，**不要邊做邊講**。

**禁止的 narration 樣式**（實際測試過會搞混使用者）：

- ❌ 「我先讀 `current-trip` 看目前在哪個行程」
- ❌ 「確認一下 `CLAUDE.md` 的 `TRIP_METADATA_START` 是不是舊版殘留，還是只是文件裡提到的字串」
- ❌ 「偵測到這是乾淨的工作區，沒有舊版資料」
- ❌ 「找不到指標檔，讓我建一個」
- ❌ 「我去 grep 一下看有沒有 marker」

**應該的做法**：

1. 靜默執行內部檢查（用 Bash / Read 工具），結果直接用來決定下一步
2. 只在**需要使用者行動時**才開口（例如真的偵測到舊版殘留要問搬遷、或真的缺資料要補）
3. 正向檢查結果（「一切正常」）**不用報告**，直接進下一步
4. 使用者看到的應該是 skill 的**結論**（「目前在規劃 **1-日本-…**，下一步是研究」），不是**過程**（「我讀了檔、grep 了 marker、確認沒殘留」）

例外：**開發者模式**（使用者明確說「我在開發 skill」「幫我 debug」）可以詳細 narration。但預設假設是一般使用者。

## 環境感知 — 分批寫入 + 頻繁進度回報

這一節**同時適用兩種情境**：

1. **改這個倉庫的 skill 原始碼**（工程師在開發 skill）
2. **執行 trip 系列 skill**（一般使用者在規劃行程） — 例如 `/trip-research` 派多個 agent、`/trip-go` 生成完整行程表、`/trip-pack` 列出每日清單，這些都是長時間 + 大檔寫入的操作

兩種情境撞到的是**同一個底層問題**：Claude 在後台做事，但使用者（尤其手機 / App 環境）看不到 tool call 細節，長時間沒文字就以為當機、或觸發 stream idle timeout。

### 兩種環境的差異

| 環境 | 特徵 | 策略 |
|---|---|---|
| **Terminal / CLI**（工程師開發、或老手使用者） | 看得到 tool call 細節、沒有嚴格 idle timeout、可容忍較長的靜默 | 可以一次 Write 大檔（幾百行沒問題），不需要每個 tool call 都回報進度，任務結束再彙報即可 |
| **App（手機 / 桌面 App / 雲端 web）** | 看不到 tool call 細節、有 5 分鐘 **stream idle timeout**（見 `docs/roadmap.md` 的已知問題）、長時間沒文字輸出會讓使用者以為 Claude 當機 | **必須分批寫入 + 頻繁回報**（見下方策略） |

### App 環境必遵守的策略

1. **大檔案（> 150 行或估計寫入會花 > 30 秒）分批寫**：
   - 先 `Write` 骨架（frontmatter + 前 1-2 節）
   - 後面用多次 `Edit` 分段追加（每段 50-100 行）
   - 每個 tool call 都會產生 token 回饋 → 重置 5 分鐘 idle 計時器
   - 適用場景：改 skill 的 SKILL.md、`/trip-go` 寫 final-itinerary、`/trip-pack` 寫 checklist

2. **每次工具呼叫前後給一句話進度更新**：
   - 不要連續跑 3+ 個 tool call 中間沒文字
   - 使用者在 App 上看不到 tool call 細節，只看得到你的文字。長時間沒字會以為 session 卡死
   - 範例（開發中）：「現在改 `/trip-research` 的路徑引用…」「這段 OK，接著改 `/trip-go`」
   - 範例（使用者跑 skill）：「派 agent 去研究美食了，預計 3 分鐘」「agent A 回來了，正在整理要點」「行程表寫到第 3 天」

3. **複雜任務一律用 `TodoWrite` 追蹤**：讓使用者在 UI 看得到「進度 3/8」這類明確狀態。`/trip-research`、`/trip-go` 派 agent 或分段寫檔時特別有用

4. **遇到 stream idle timeout 中斷時**：不要放棄，檢查 `git status` 確認哪些檔案已寫入、哪些還沒，從中斷點繼續。已寫入的通常已存檔不會丟失

### 環境判斷啟發式

- **看不出來時，默認假設是 App 環境**（比較保守，不會出錯）
- 使用者明說「我在 terminal」「我在 CLI」「我在 iTerm」時 → 切到 Terminal 模式
- 使用者訊息裡出現手機截圖、說「手機 App」「Claude app」、問 UI 相關問題 → 鎖定 App 模式
- `docs/roadmap.md` 的「Stream idle timeout」條目是這個策略的背景

## 派 sub-agent 通則（輕量版）

凡用 Task tool 派 sub-agent 出去做事（無論在 trip-* skill 內或隨手任務），遵守下列原則。具體實作範例見 `.claude/skills/trip-research/SKILL.md`（已踩過坑、有完整流程）。

### A. 啟動門檻 — 不是所有任務都該派 agent

先用主執行緒判斷：

- **預估 < 3 分鐘** + **不需平行**（單一獨立任務）→ **不派 agent**，主 Claude 直接做（連續 WebSearch / WebFetch + 邊做邊講進度）
- 過上面門檻才適用以下 B-E

### B. Mode 選擇 — 每趟旅行第一次派 agent 前詢問

不同 Claude 訂閱方案的 token 預算差很多，**直接寫死「派 N 個 agent」會讓 Pro 用戶爆配額**。所以第一次派 agent 前要問使用者：

| Mode | 適合 | 做法 |
|---|---|---|
| 🟢 **No-agent mode**（Pro 友善） | Claude Pro / 配額緊 / 想省 | 主 Claude 自己連續跑搜尋，每完成一塊就 Edit 寫檔（保持輸出格式跟 multi-agent 相容） |
| 🔵 **Multi-agent mode**（Max 友善） | Claude Max（5x / 20x）/ 大量平行任務 | 派 sub-agent 平行做 |

詢問範例（用最白話、不要用「sub-agent / 配額 / token」這類術語）：

> 這趟旅行第一次要研究資料了。問你一下，你 Claude 訂閱是哪個？
> - **Pro 版**：我自己慢慢跑（約 8-10 分鐘，比較省）
> - **Max 版**：派幾個小幫手平行做（約 3 分鐘，比較快但會吃較多配額）
>
> 答案會記到這趟旅行的設定，下次自動沿用。

答案存進該趟旅行的 `trip-meta.md` 的「Claude 模式」欄位（值：`no-agent` / `multi-agent` / `尚未設定`）。下次跑同個 skill 直接讀，不重複問。

### C. Multi-agent mode — 動態決定 agent 數量（不寫死公式）

過了 B 走 Multi-agent，主 Claude 自己估**獨立子題數 + 平行價值 + 總工作量**動態決定派多少 agent。經驗值：

| 獨立子題 | 派 agent 數 | 派送方式 |
|---|---|---|
| 1-3 | 1 個 | 單獨派 |
| 4-9 | 3-4 個 | 一輪同 message 並行派 |
| 10-30 | 5-10 個迷你 agent | 一輪上限 ~10 個（一輪 ≥ 11 會吃太多 main token） |
| 30+ | > 10 個迷你 agent | 分多輪派發（輪間講一句進度文字，避免 idle timeout） |

每個 agent 派出去都用 `run_in_background: true` 別 blocking 主對話。

### D. 序列依賴 — agent B 用 agent A 的結果

如果 agent B 要等 agent A 的結果才能派（例：gate agent → 主研究 agent；研究 agent → 行程排程），**分輪派發**：

1. 派第 1 輪獨立 agent → 等回來 → 講一句「第 1 輪完，準備下一輪」
2. 用第 1 輪結果決定第 2 輪 agent 怎麼派
3. 派第 2 輪 → 收尾

**不要在 agent prompt 裡寫「等 agent A 完成再做」** — sub-agent 看不到其他 agent 的執行狀態。

### E. 進度可見性 + 失敗處理

- **進度可見性**接「環境感知」章節既有規則（每個 tool call 前後給一句話、TodoWrite 追蹤、回報就講）— 不重複。
- **失敗處理**：
  - 單一 agent fetch 403 / 抓不到網頁 → 改用 WebSearch 拼湊，**報告開頭加「⚠️ 資料來源不完整」標註**，不要硬重試 > 2 次
  - **> 30% agent 同時失敗** → 高機率撞 usage limit。**停手**，用 `AskUserQuestion` 問使用者三個選項：
    1. 等 limit 重置後重派（最完整）
    2. 用簡化 prompt 立刻重派（搜尋預算砍半）
    3. 拿現有資料前進，缺的部分 disclaim
  - 詳見 trip-research SKILL.md「第五階段：回收 + 完成度檢查 + 失敗回復」

### 跟現有規則的關係

- **「環境感知」章節**：派 agent 期間的進度可見性（每個 tool call 前後給文字、TodoWrite 追蹤）規則寫在那邊，不重複
- **「內部檢查必須靜默執行」章節**：「派 agent 是使用者看得見的進度，必須講」 — 但不要 narrate 「我在算 ceil()」這類內部計算
- **「措辭硬規則」章節**：對使用者**禁用「sub-agent / 配額 / token」**這類技術詞，問 Mode 時要白話（範例見上方 B 段）

## 舊版（單行程）資料的相容提示

**早期版本**的 trip skills 把 `CLAUDE.md`（含 `<!-- TRIP_METADATA_START -->` marker）、`traveler-profile.md`、`research/`、`final-itinerary.md` 等**全部放在倉庫根目錄**（一個倉庫只能放一趟）。

新版改成「一個倉庫多個編號行程資料夾」。若 `/trip` 偵測到根目錄有舊版檔案（CLAUDE.md 含 TRIP_METADATA marker、根目錄有 research/ 或 final-itinerary.md），請主動詢問使用者是否把舊資料搬進 `1-{舊目的地}-{今日}/` 資料夾完成遷移，不要直接刪或覆蓋。
