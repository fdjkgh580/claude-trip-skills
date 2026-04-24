# 旅途中在手機上怎麼用

出國後不會帶筆電？這一段給你看。

## 主線用法：手機當聊天助手（推薦給多數人）

- 用手機安裝 [Claude iOS / Android app](https://claude.ai/download)，登入同一個 Claude 帳號
- 旅途中可以做的事：
  - **記帳**：隨口說「剛剛午餐 25 歐元」Claude 會記住（但這份記錄在手機對話裡，不會寫回電腦上的 `expense-log.md`）
  - **找資訊**：「離我最近的地鐵站？」「這家店幾點關？」
  - **緊急應對**：「我被扒了怎麼辦」「這家餐廳排太久有附近其他推薦嗎」
- 限制：手機 app 看不到你出發前在電腦上建的行程檔案（`trip-meta.md` / 行程表 / 研究報告）。手機聊天和電腦上的規劃是**兩條獨立的對話**

## 想在手機跑完整規劃流程？用 GitHub template

規劃文件是會持續編輯的 markdown 檔，**只有 GitHub 能真的雙向同步**。Notion / iCloud / Apple Notes 那類雲端筆記只能做一次性快照、無法把手機修改回流到電腦，也無法被 Claude 讀寫，不適合當規劃工作流。

### 流程

1. 在電腦或手機瀏覽器開 https://github.com/fdjkgh580/claude-trip-skills，點 **Use this template** 建一個自己的 repo（建議 private，例如 `my-paris-trip`）
2. 手機 Claude app 切到 **code 標籤**，指定剛建的 repo 開新對話
3. 先打一句「hi」讓 Claude 載入專案（[為什麼要先 hi？](environments.md#重要載入時機已實測)）
4. 打 `/trip` 開始規劃

### 雙向同步邏輯

- 手機改完 commit & push → 電腦端 `git pull` 拿到最新版
- 電腦改完 commit & push → 手機端在 claude.ai/code 介面 pull 或重新整理

好處：行程即時同步、雙向編輯、記帳寫回檔案。
代價：要熟悉 GitHub commit / push（手機 Claude app 的 code 標籤通常會幫你按按鈕完成，不一定要自己打指令）。

> 💡 沒有 GitHub 帳號？[到這註冊](https://github.com/signup)，免費。
