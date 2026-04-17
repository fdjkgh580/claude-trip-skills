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
| 4. 幫你檢查 | `/trip-review` | 自動查 21 項常見錯誤（星期寫錯、景點沒開、轉機來不及、時差沒考慮、費用算錯等），查到就直接修正 |
| 5. 打包清單 | `/trip-pack` | 依你的目的地和興趣生成行前準備清單（攝影→備用記憶卡、家庭→依小孩年齡列不同物品） |

> 💡 **記不住順序也沒關係：**隨時打 `/trip` 就會告訴你目前進度和下一步該做什麼。

### 旅途中（不需要打任何指令，直接聊天）

| 你說什麼 | Claude 會做什麼 |
|---------|---------------|
| 「午餐花了 25 歐元」 | 自動記帳，更新花費紀錄 |
| 「今天花了多少？」 | 算給你看，跟預算比較 |
| 「下雨了，艾菲爾鐵塔去不了」 | 從備案中找室內替代方案 |
| 「這家餐廳排隊太長」 | 搜尋附近其他推薦 |
| 「多出兩小時空檔」 | 根據你的位置和興趣推薦附近去處 |
| 「我被扒了怎麼辦」 | 立刻提供報案地點、駐外館處電話 |

## 安裝方法

### 你需要先有

- **Claude Code** — Anthropic 的 AI 工具。有三種使用方式：
  - **桌面 App（最簡單，Mac / Windows 都可）**：下載 [Claude 桌面版](https://claude.ai/download)，打開後切到 **Cowork** 或 **Code** 分頁就是 Claude Code
  - **Web 版**：到 [claude.ai](https://claude.ai) 登入後切到 Cowork / Code 分頁
  - **終端機 CLI（進階）**：Mac 用 `brew install --cask claude-code`、Windows / Linux 請到 [安裝指南](https://code.claude.com/docs/en/overview) 看系統對應指令
- Claude **Pro** 或 **Max** 訂閱

> 💡 **Windows 使用者**：本 repo 作者用 Mac 開發、手邊沒有 Windows 機器，Windows 相關說明皆屬推測。若你是 Windows 使用者實測順利或發現問題，歡迎開 Issue / PR 修正說明。以下設定在 Windows 上的等價做法：
>
> | Mac / Linux | Windows |
> |-------------|---------|
> | `~/.claude/skills/` | `%USERPROFILE%\.claude\skills\` |
> | 終端機 / Terminal | PowerShell |
> | Finder | 檔案總管 |
> | `brew install` | 請看官方安裝指南 |

### 方法一：在 Claude Code 裡貼一句話（推薦，不需要任何技術背景）

打開 Claude Code（桌面 App、Web 版、或終端機都行），把下面這句話貼到對話框，按送出：

> 幫我安裝這個旅行規劃技能包：https://github.com/fdjkgh580/claude-trip-skills

Claude 會自己下載、安裝、搞定一切。看到它說安裝完成後，照下面「開始之前」的步驟建好旅行資料夾，就可以打 `/trip` 開始。

### 方法二：手動下載再匯入（不想讓 Claude 碰你的檔案系統時）

1. 到 [GitHub 頁面](https://github.com/fdjkgh580/claude-trip-skills)，點綠色的 **Code** 按鈕 → **Download ZIP**
2. 解壓縮下載的 ZIP 檔
3. 打開 Claude Code，跟它說：

> 我下載了旅行規劃技能包，解壓在「下載」資料夾裡的 claude-trip-skills-main，幫我安裝起來

Claude 會幫你把檔案放到正確的位置。

### 方法三：一行指令安裝（工程師適用，僅 Mac / Linux）

```bash
git clone https://github.com/fdjkgh580/claude-trip-skills.git /tmp/claude-trip-skills && cp -r /tmp/claude-trip-skills/skills/trip-* ~/.claude/skills/ && rm -rf /tmp/claude-trip-skills
```

Windows 使用者請改用方法一或方法二，或自行在 PowerShell 對應寫法。

### 方法四：Clone + symlink（想自己改 skill 內容時用，僅 Mac / Linux）

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

## 開始之前：建一個專屬資料夾

每趟旅行都用一個專屬資料夾。Claude 會把行程、研究報告、記帳檔等全部存在這個資料夾裡，**不同旅行互不干擾**。

### 桌面 App / Web 版

1. 開啟 Finder（Mac）或檔案總管（Windows），在你常放檔案的地方建一個新資料夾，例如 `Trips/巴黎-2026春`
2. 打開 Claude Code，選擇剛剛建的資料夾來開新對話（左上角 + 號 → 選擇資料夾）
3. 在那個對話裡打 `/trip` 就會開始

### 終端機 CLI（Mac / Linux）

```bash
mkdir -p ~/Trips/巴黎-2026春
cd ~/Trips/巴黎-2026春
claude
```

Windows PowerShell 對應寫法（未經實測，僅供參考）：
```powershell
mkdir $env:USERPROFILE\Trips\巴黎-2026春
cd $env:USERPROFILE\Trips\巴黎-2026春
claude
```

進去後打 `/trip`。

> 💡 **不確定該打什麼？永遠先打 `/trip`。** 它會看你的進度告訴你下一步。第一次用會引導你跑 `/trip-plan`，之後每一步都會接著告訴你。

## 旅途中在手機上怎麼用

出國後不會帶筆電？這一段給你看。

### 主線用法：手機當聊天助手（推薦給多數人）

- 用手機安裝 [Claude iOS / Android app](https://claude.ai/download)，登入同一個 Claude 帳號
- 旅途中可以做的事：
  - **記帳**：隨口說「剛剛午餐 25 歐元」Claude 會記住（但這份記錄在手機對話裡，不會寫回電腦上的 `expense-log.md`）
  - **找資訊**：「離我最近的地鐵站？」「這家店幾點關？」
  - **緊急應對**：「我被扒了怎麼辦」「這家餐廳排太久有附近其他推薦嗎」
- 限制：手機 app 看不到你出發前在電腦上建的 `CLAUDE.md` / 行程表 / 研究報告。手機聊天和電腦上的規劃是**兩條獨立的對話**

**如果你希望手機也能看到出發前的規劃**，可以：
- 把行程表 Markdown 複製到 Notion、Apple Notes 等雲端筆記 app，手機開啟查看
- 出發前把行程表內容貼給手機 Claude 一次，讓它當背景知識

### 進階用法：GitHub 同步（適合懂 git 的使用者）

如果你會用 GitHub，可以讓手機和電腦讀寫同一份規劃檔：

1. 在電腦上把旅行專案資料夾 push 到一個 GitHub private repo
2. 手機 Claude Code app（iOS / Android 支援者）選取該 GitHub repo 作為工作空間
3. 手機 Claude 就能讀取 / 編輯 `CLAUDE.md`、行程表、記帳檔等
4. 修改後 commit 回 GitHub，電腦端 pull 下來就是最新版本

好處：行程即時同步雙向編輯、記帳寫回檔案。代價：要熟悉 git workflow（push / pull / commit）。

## 特色功能

### 懂你的旅行風格

每次新旅行會問你幾個問題（用選擇題，不用打字），偏好存在這趟旅行的資料夾裡。中途離開沒關係，下次打開資料夾就能接續規劃。每趟旅行各自獨立，幫家人或朋友規劃時不會互相干擾。

### 攝影、美食、戶外⋯⋯不同興趣，不同行程

不是每個人的行程都該長一樣。攝影愛好者的行程會先卡日出和黃金光線時段，美食控會先卡餐廳營業時間，家庭旅行會預留小孩午睡時段。

### 自動記帳

旅途中隨口說「咖啡花了 300」就自動記錄，支援多種幣別（歐元、英鎊混用沒問題），回國後有完整花費紀錄。

### 幫你抓錯

行程排好後自動檢查 21 項（家庭旅行 24 項）：星期有沒有寫錯、景點那天是不是休館、轉機時間夠不夠、跨洲第一天是不是排太滿沒考慮時差、費用有沒有算錯。發現問題直接修正。

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

## Roadmap（之後版本想做的）

以下是評估後暫緩、之後可能納入的功能。歡迎在 Issue 提出使用情境或需求，幫助判斷優先級：

- **匯出能力**：把行程表匯出為 `.ics`（行事曆檔）、`.csv`（試算表）、`.kml`（Google Maps 釘點）、PDF（分享給不用 Claude 的朋友）
- **跨旅行畫像繼承**：一年跑多趟旅行的人可以從上次專案複製畫像，不用重填
- **時效性標記強制化**：票價、營業時間、特展等會變動的資訊，超過一段時間自動標「請出發前再次確認」
- **多人分帳計算**：記帳檔升級為誰付 / 誰欠誰的分帳，不離開 Claude 就完成 Splitwise 類功能

有需求？到 [Issues](https://github.com/fdjkgh580/claude-trip-skills/issues) 提一聲。

## 授權

MIT — 自由使用、修改、分享。
