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

## 30 秒上手

1. 下載 [Claude 桌面 App](https://claude.ai/download)（最簡單）或開 [claude.ai](https://claude.ai)
2. 把這句話貼給 Claude：
   > 幫我安裝這個旅行規劃技能包：https://github.com/fdjkgh580/claude-trip-skills
3. 在 Finder 建一個資料夾（例如 `Trips/巴黎-2026春`），用它開新對話
4. 打 `/trip`，Claude 會帶你接下來的每一步

> 💡 **不確定該打什麼？永遠先打 `/trip`。** 它會看你的進度告訴你下一步。

其他安裝方式（手動下載、git clone、symlink、Windows）→ 看 [docs/install.md](docs/install.md)

## 在哪些環境可以用？

| 環境 | 是否能用 trip skills |
|------|------|
| 桌面 App / 終端機 / IDE 擴充 | ✓ 個人安裝即可 |
| **claude.ai/code（網頁版）** | ⚠️ 須把 skills 放進專案 repo 的 `.claude/skills/` |
| claude.ai 一般對話 | ✓ 透過 Settings → Customize 上傳 |

詳細差異與 claude.ai/code 的具體做法 → 看 [docs/environments.md](docs/environments.md)

## 開始之前：建一個專屬資料夾

每趟旅行用一個獨立資料夾，Claude 會把行程、研究報告、記帳檔全部存在裡面，不同旅行互不干擾。

**桌面 App / Web 版：**Finder 或檔案總管建資料夾（例如 `Trips/巴黎-2026春`），打開 Claude Code 用「+ 號」選擇這個資料夾開新對話，進去打 `/trip`。

**終端機 CLI：**
```bash
mkdir -p ~/Trips/巴黎-2026春
cd ~/Trips/巴黎-2026春
claude
```

進去後打 `/trip`。

## 更多文件

- [安裝指南](docs/install.md) — 四種安裝方法、Windows 對照、選配 MCP
- [環境支援](docs/environments.md) — 桌面/CLI/Web/code 各環境的差異與限制
- [手機用法](docs/mobile.md) — 旅途中怎麼在手機上用
- [特色功能](docs/features.md) — 風格識別、自動記帳、抓錯、家庭旅行
- [常見問題](docs/faq.md)
- [Roadmap](docs/roadmap.md)

## 授權

MIT — 自由使用、修改、分享。
