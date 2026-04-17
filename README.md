# Claude Trip Skills ✈️

讓 Claude 變成你的**旅行規劃助手** — 從認識你的旅行風格、研究目的地、排行程、幫你記帳，到旅途中即時應對突發狀況，全部用對話完成。

## 這是什麼？

這是一套給 [Claude Code](https://code.claude.com/)（Anthropic 的 AI 開發工具）使用的旅行規劃技能包。安裝後，你只要打幾個指令，Claude 就會一步步幫你規劃整趟旅行。

**不需要寫程式，不需要懂技術。** 整個過程就像在跟一個很懂旅行的朋友聊天。

## 能幫你做什麼？

### 出發前

| 步驟 | 你打什麼 | Claude 會做什麼 |
|------|---------|---------------|
| 1. 認識你 | `/trip-plan` | 用選擇題問你的旅行風格（獨旅？家庭？攝影控？美食家？），記住你的偏好 |
| 2. 研究目的地 | `/trip-research` | 同時派出多個 AI 助手查景點、美食、交通、安全、住宿，5-10 分鐘產出完整報告 |
| 3. 排行程 | `/trip-go` | 根據你的興趣排出每日行程（攝影→先卡日出黃金光線、美食→先卡餐廳時段），附 Google Maps 連結 |
| 4. 幫你檢查 | `/trip-review` | 自動查 15 項常見錯誤（星期寫錯、景點沒開、交通來不及、費用算錯），查到就直接修正 |
| 5. 打包清單 | `/trip-pack` | 依你的目的地和興趣生成行前準備清單（攝影→備用記憶卡、家庭→依小孩年齡列不同物品） |

### 旅途中（不需要打任何指令，直接聊天）

| 你說什麼 | Claude 會做什麼 |
|---------|---------------|
| 「午餐花了 3000 福林」 | 自動記帳，更新花費紀錄 |
| 「今天花了多少？」 | 算給你看，跟預算比較 |
| 「下雨了，漁人堡去不了」 | 從備案中找室內替代方案 |
| 「這家餐廳排隊太長」 | 搜尋附近其他推薦 |
| 「多出兩小時空檔」 | 根據你的位置和興趣推薦附近去處 |
| 「我被扒了怎麼辦」 | 立刻提供報案地點、駐外館處電話 |

## 安裝方法

### 你需要先有

- **Claude Code** — Anthropic 的 AI 工具。有三種使用方式：
  - **桌面 App**：下載 [Claude 桌面版](https://claude.ai/download)，打開後切到 **Cowork** 或 **Code** 分頁就是 Claude Code
  - **Web 版**：到 [claude.ai](https://claude.ai) 登入後切到 Cowork / Code 分頁
  - **終端機 CLI**：`brew install --cask claude-code`（Mac）或到 [安裝指南](https://code.claude.com/docs/en/overview) 看其他系統
- Claude **Pro** 或 **Max** 訂閱

### 方法一：在 Claude Code 裡貼一句話（推薦，不需要任何技術背景）

打開 Claude Code（桌面 App、Web 版、或終端機都行），把下面這句話貼到對話框，按送出：

> 幫我從 https://github.com/fdjkgh580/claude-trip-skills 安裝旅行規劃 skills 到 ~/.claude/skills/

Claude 會自己下載、安裝、搞定一切。看到它說安裝完成後，輸入 `/trip-plan` 就可以開始規劃旅行了。

### 方法二：手動下載再匯入（不想讓 Claude 碰你的檔案系統時）

1. 到 [GitHub 頁面](https://github.com/fdjkgh580/claude-trip-skills)，點綠色的 **Code** 按鈕 → **Download ZIP**
2. 解壓縮下載的 ZIP 檔
3. 打開 Claude Code，跟它說：

> 我下載了旅行規劃 skills，解壓在「下載」資料夾裡的 claude-trip-skills-main，幫我安裝到 ~/.claude/skills/

Claude 會幫你把檔案放到正確的位置。

### 方法三：一行指令安裝（工程師適用）

```bash
git clone https://github.com/fdjkgh580/claude-trip-skills.git /tmp/claude-trip-skills && cp -r /tmp/claude-trip-skills/skills/trip-* ~/.claude/skills/ && rm -rf /tmp/claude-trip-skills
```

### 方法四：Clone + symlink（想自己改 skill 內容時用）

把 repo clone 到本機，跑 `install.sh` 會在 `~/.claude/skills/` 建立 symlink 連回 repo。之後你改 repo 裡的檔案就直接生效，不用兩邊同步。

```bash
git clone https://github.com/fdjkgh580/claude-trip-skills.git ~/Projects/claude-trip-skills
cd ~/Projects/claude-trip-skills
./scripts/install.sh
```

換電腦時重複上面 3 行就可以還原。

### （選配）機票搜尋功能

想讓 Claude 幫你搜尋機票？在 Claude Code 裡貼上：

```bash
claude mcp add kiwi-com --transport http https://mcp.kiwi.com
```

沒裝也沒關係，Claude 會改用網路搜尋給你參考價格和訂票平台。

## 特色功能

### 懂你的旅行風格

每次新旅行會問你幾個問題（用選擇題，不用打字），偏好存在這趟旅行的資料夾裡。中途離開沒關係，下次打開資料夾就能接續規劃。每趟旅行各自獨立，幫家人或朋友規劃時不會互相干擾。

### 攝影、美食、戶外⋯⋯不同興趣，不同行程

不是每個人的行程都該長一樣。攝影愛好者的行程會先卡日出和黃金光線時段，美食控會先卡餐廳營業時間，家庭旅行會預留小孩午睡時段。

### 自動記帳

旅途中隨口說「咖啡花了 300」就自動記錄，支援多種幣別（歐元、福林混用沒問題），回國後有完整花費紀錄。

### 幫你抓錯

行程排好後自動檢查：星期有沒有寫錯、景點那天是不是休館、交通時間夠不夠、費用有沒有算錯。發現問題直接修正。

### 家庭旅行友善

帶小孩出國？Claude 會根據小孩年齡調整：問推車能不能進景點、幫你安排午睡時段、提醒兒童餐要提前申請、行前清單依年齡分層（0-3 歲要帶尿布、3-6 歲要帶防走失手環）。

## 常見問題

**Q: 我不會用命令列 / 終端機，可以用嗎？**
A: 可以。下載 [Claude 桌面 App](https://claude.ai/download)，打開後在 Cowork 或 Code 分頁操作，跟聊天一樣。你只需要會打字和點選就好。

**Q: 需要付費嗎？**
A: 這個技能包免費。但你需要 Claude Code 的訂閱（Claude Pro 或 Max）才能使用。

**Q: 可以規劃多國行程嗎？**
A: 可以。跨國旅行的記帳會自動處理多幣別，全程花費換算成台幣方便加總。

**Q: 行程排好後可以改嗎？**
A: 可以，隨時跟 Claude 說你想改什麼，它會直接修改行程表。旅途中臨時變更也會自動記錄。

**Q: 支援英文嗎？**
A: 目前 skill 指令是繁體中文，Claude 的回覆也是繁體中文。如果你需要英文版，歡迎發 Issue 或 PR。

## 授權

MIT — 自由使用、修改、分享。
