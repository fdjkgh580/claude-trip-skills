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

## 規劃開始後

當使用者跑完 `/trip-plan`，這份 CLAUDE.md 會被替換為**旅行專屬**版本（檔頭會保留同樣的「trip skills 在此為合法」指示，避免後續流程被誤判）。
