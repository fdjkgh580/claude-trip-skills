# Claude Trip Skills ✈️

讓 Claude 變成你的**旅行規劃助手** — 從認識你的旅行風格、研究目的地、排行程、幫你記帳，到旅途中即時應對突發狀況，全部用對話完成。

## 這是什麼？

這是一套給 [Claude Code](https://code.claude.com/)（Anthropic 的 AI 開發工具）使用的旅行規劃技能包。安裝後，你只要打幾個指令，Claude 就會一步步幫你規劃整趟旅行。

**不需要寫程式，不需要懂技術。** 整個過程就像在跟一個很懂旅行的朋友聊天。

## 怎麼用？只記一句話

> **只要記 `/trip`** — 或直接跟 Claude 說「下一步」「進度」「規劃旅行」都會觸發。

打了之後 Claude 會偵測你目前進度、用選項按鈕問你「要不要現在跑下一步？」點下去就走，**完全不用記其他指令**。

手機族尤其推薦這套用法 — 不用打那些長長的 slash command。

### 出發前 Claude 會帶你跑這 5 步（背景流程，知道就好不用記）

| 步驟 | Claude 會做什麼 |
|------|---------------|
| 1. 認識你 | 用選擇題問你的旅行風格（獨旅？家庭？攝影控？美食家？），記住你的偏好 |
| 2. 研究目的地 | 同時派出多個 AI 助手查景點、美食、交通、安全、住宿，5-10 分鐘產出完整報告 |
| 3. 排行程 | 根據你的興趣排出每日行程（攝影→先卡日出黃金光線、美食→先卡餐廳時段），附 Google Maps 連結 |
| 4. 幫你檢查 | 自動查 22 項常見錯誤（星期寫錯、景點沒開、轉機來不及、時差沒考慮、費用算錯等），查到就直接修正 |
| 5. 打包清單 | 依你的目的地和興趣生成行前準備清單（攝影→備用記憶卡、家庭→依小孩年齡列不同物品） |

<details>
<summary>進階：完整指令清單（一般人不用看）</summary>

如果你想跳過 `/trip` 直接打對應步驟也行：

| 指令 | 對應步驟 |
|---|---|
| `/trip-plan` | 1. 認識你 |
| `/trip-research` | 2. 研究目的地 |
| `/trip-go` | 3. 排行程 |
| `/trip-review` | 4. 檢查錯誤 |
| `/trip-pack` | 5. 打包清單 |
| `/backup` | 把變更存到雲端（也可以直接說「儲存」「save」「備份」） |

</details>

### 旅途中（不需要打任何指令，直接聊天）

| 你說什麼 | Claude 會做什麼 |
|---------|---------------|
| 「午餐花了 25 歐元」 | 自動記帳，更新花費紀錄 |
| 「今天花了多少？」 | 算給你看，跟預算比較 |
| 「下雨了，艾菲爾鐵塔去不了」 | 從備案中找室內替代方案 |
| 「這家餐廳排隊太長」 | 搜尋附近其他推薦 |
| 「多出兩小時空檔」 | 根據你的位置和興趣推薦附近去處 |
| 「我被扒了怎麼辦」 | 立刻提供報案地點、駐外館處電話 |

## 兩種使用方式，挑一個

### 路徑 A：手機 / claude.ai/code 使用者（不用裝任何東西）

1. 開 https://github.com/fdjkgh580/claude-trip-skills
2. 點綠色的「Use this template」→「Create a new repository」→ 命名（例如 `my-paris-trip`）→ 建議選 private → Create
3. 在 claude.ai/code 或手機 Claude app 的 code 標籤，指定剛建的 repo 開新對話
4. 先打個招呼（例如「hi」）讓 Claude 載入專案 — 這步必要，第一次還掃不到 skills
5. 接著打 `/trip` 或直接說「規劃旅行」，Claude 會問你要不要開始，點選擇就好

### 路徑 B：桌面 App / CLI 使用者（裝一次到全域，所有專案通用）

```bash
git clone https://github.com/fdjkgh580/claude-trip-skills.git ~/Projects/claude-trip-skills
cd ~/Projects/claude-trip-skills
./scripts/install.sh
```

裝完後在任何旅行資料夾打 `/trip`（或說「下一步」「規劃旅行」）都生效。詳細說明 → [docs/install.md](docs/install.md)

## 在哪些環境可以用？

| 環境 | 怎麼用 |
|------|------|
| 桌面 App / 終端機 / IDE 擴充 | 路徑 B 裝到全域 |
| claude.ai/code（網頁版） | 路徑 A 用 template repo |
| 手機 Claude app（iOS / Android） | 路徑 A 用 template repo，在 code 標籤打開 |
| claude.ai 一般對話 | 透過 Settings → Customize 上傳（跟 Claude Code 是兩條獨立對話） |

詳細差異與限制 → [docs/environments.md](docs/environments.md)

## 更多文件

- [安裝指南](docs/install.md) — 兩條路線（template / install.sh）詳細步驟、升級方式
- [環境支援](docs/environments.md) — 各環境差異、claude.ai/code 載入時機（要先送一句訊息才會掃 skills）
- [手機用法](docs/mobile.md) — 旅途中怎麼在手機上用
- [特色功能](docs/features.md) — 風格識別、自動記帳、抓錯、家庭旅行
- [常見問題](docs/faq.md)
- [Roadmap](docs/roadmap.md)

## 授權

MIT — 自由使用、修改、分享。
