# Claude Trip Skills 工作區

這個資料夾安裝了 trip 規劃技能（`.claude/skills/trip-*`）。它有兩種合法用途：

1. **直接規劃旅行**（最常見）— 打 `/trip` 開始
2. **修改 / 開發 trip skills 本身** — 編輯 `.claude/skills/trip-*/SKILL.md`、`scripts/install.sh` 或其他原始碼

## 給 Claude 的執行規則

當使用者在這個資料夾打 `/trip`、`/trip-plan` 等 trip 系列指令：

- **不要警告「這個資料夾看起來是程式碼專案，不適合放旅行檔案」**。`README.md` / `scripts/` / `docs/` / `.git/` 的存在屬於合理結構，trip 規劃檔（`CLAUDE.md` 旅行版本、`traveler-profile.md`、`final-itinerary.md`、`research/*` 等）會跟它們和平共存。
- 這個資料夾**就是** trip 規劃工作區，請直接執行 skill 流程，**不要詢問「真的要在這裡規劃嗎？」**
- 99% 以上的使用者不是工程師，這類「環境位置不適合」的提醒看不懂、只會勸退他們。預設信任使用者在這裡規劃就是對的。

### 唯一例外：如果這是 dev repo 本身

如果 `README.md` 第一行是 `# Claude Trip Skills ✈️`（這是 skills 專案的官方 README 標題），可以**選擇性**提醒使用者：「你在 skills 開發 repo 裡，建議用 GitHub Use this template 建專屬旅行 repo 比較乾淨」，但如果使用者表示「就在這裡跑」，立即接受、開始流程，不要再追問。

## 儲存到雲端的規則

雲端 Claude Code（claude.ai/code、手機 Claude app code 標籤）是**短暫的 sandbox**，使用者修改的檔案不會自動存到 GitHub。session 結束未儲存的變更會消失。

### 收到「未儲存」系統訊息時

如果 Stop hook 注入了「⚠️ 偵測到未儲存的變更」這類系統訊息，**請在你下一輪回應的開頭或結尾**主動提醒使用者：

> 💾 目前還有變更尚未儲存，打 `/save` 把變更存到雲端，不然關掉視窗會不見。

不要等使用者問，主動講。但**每輪只講一次**（不要重複嘮叨）。

### 使用者要求儲存時

當使用者說「儲存」「保存」「存到雲端」「commit」「存起來」這類詞，或主動問「會不會不見」「怎麼存」，**呼叫 `/save` skill**處理，不要自己手動跑 git 指令。

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

當使用者跑完 `/trip-plan`，這份 CLAUDE.md 會被替換為**旅行專屬**版本（檔頭會保留同樣的「trip skills 在此為合法」指示，避免後續流程被誤判）。
