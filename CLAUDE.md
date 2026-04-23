# Claude Trip Skills 工作區

這個資料夾安裝了 trip 規劃技能（`.claude/skills/trip-*`）。它有兩種合法用途：

1. **直接規劃旅行**（最常見）— 打 `/trip` 開始
2. **修改 / 開發 trip skills 本身** — 編輯 `.claude/skills/trip-*/SKILL.md`、`scripts/install.sh` 或其他原始碼

## 給 Claude 的執行規則

當使用者在這個資料夾打 `/trip`、`/trip-plan` 等 trip 系列指令：

- **不要警告「這個資料夾看起來是程式碼專案，不適合放旅行檔案」**。`README.md` / `scripts/` / `docs/` / `.git/` 的存在屬於合理結構，trip 規劃檔（`CLAUDE.md` 旅行版本、`traveler-profile.md`、`final-itinerary.md`、`research/*` 等）會跟它們和平共存。
- 這個資料夾**就是** trip 規劃工作區，請直接執行 skill 流程，**不要詢問「真的要在這裡規劃嗎？」**
- 99% 以上的使用者不是工程師，這類「環境位置不適合」的提醒看不懂、只會勸退他們。預設信任使用者在這裡規劃就是對的。

## 儲存到雲端的規則

雲端 Claude Code（claude.ai/code、手機 Claude app code 標籤）是**短暫的 sandbox**，使用者修改的檔案不會自動存到 GitHub。session 結束未儲存的變更會消失。

### 收到「未儲存」系統訊息時

如果 Stop hook 注入了「⚠️ 偵測到未儲存的變更」這類系統訊息，**請在你下一輪回應的開頭或結尾**主動提醒使用者：

> 💾 目前還有變更尚未儲存，打 `/save` 把變更存到雲端，不然關掉視窗會不見。

不要等使用者問，主動講。但**每輪只講一次**（不要重複嘮叨）。

### 強制使用 /save：禁止手動跑 git 寫入操作

**任何**需要 commit / push / merge / checkout / branch 切換的時刻，**一律呼叫 `/save` skill**，**絕對禁止**自己跑這些指令。

觸發 /save 的所有情境：

- ✓ 使用者說「儲存」「保存」「存到雲端」「commit」「存起來」「會不會不見」 → 呼叫 /save
- ✓ 你（Claude）剛寫完檔案、覺得「該存了」 → 呼叫 /save，**不要自己跑 git**
- ✓ 對話接近結束、想留一份備份 → 呼叫 /save
- ✓ trip 系列 skill 寫完檔後 → 呼叫 /save，**不要自己跑 git**

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

理由：/save 內部負責完整流程（commit → 推 feature branch → 切 main → merge → 推 main → 刪 feature branch → 留在 main）。手動跑 git 會繞過這個流程，導致資料卡在 feature branch、main 永遠空，使用者下次找不到。

### 使用者問起 git/branch 概念時

如果使用者主動問「我在哪個 branch」「為什麼有 claude/xxx 那串東西」「main 怎麼沒更新」之類問題：

1. **不要直接秀技術 branch 名**（例如 `claude/create-helloworld-md-WsjrB`）
2. 用最白話回答：「目前在工作版本，沒整理到主線」
3. **主動呼叫 /save**：「我幫你整理一下，整理完就只剩主線一個版本，乾乾淨淨」
4. /save 跑完後，使用者就停在 main，下次也不會再看到 branch 名

**唯一例外**：如果使用者用了「branch」「checkout」「merge」這類詞並表現出懂 git，可以正常用術語回答。但仍要主動 invoke /save 處理 merge 到 main。

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

99% 使用者不是工程師。看到 git 術語會立刻迷失。

## 規劃開始後

當使用者跑完 `/trip-plan`，trip-plan 會在這份 CLAUDE.md **末尾附加**一段旅行專屬 metadata（用 `<!-- TRIP_METADATA_START -->` 跟 `<!-- TRIP_METADATA_END -->` 標記包起來）。

**重要**：上面這些 skill 規則（執行規則、強制 /save、措辭硬規則等）**永遠不會被覆蓋**，會跟旅行 metadata 共存。

如果你看到本檔末尾有 `<!-- TRIP_METADATA_START -->` marker，那就是當前旅行的狀態與行程概要，請當作工作上下文使用。讀取 metadata 時請只讀 marker 之間的內容。
