# 旅途中在手機上怎麼用

出國後不會帶筆電？這一段給你看。

## 主線用法：手機當聊天助手（推薦給多數人）

- 用手機安裝 [Claude iOS / Android app](https://claude.ai/download)，登入同一個 Claude 帳號
- 旅途中可以做的事：
  - **記帳**：隨口說「剛剛午餐 25 歐元」Claude 會記住（但這份記錄在手機對話裡，不會寫回電腦上的 `expense-log.md`）
  - **找資訊**：「離我最近的地鐵站？」「這家店幾點關？」
  - **緊急應對**：「我被扒了怎麼辦」「這家餐廳排太久有附近其他推薦嗎」
- 限制：手機 app 看不到你出發前在電腦上建的 `CLAUDE.md` / 行程表 / 研究報告。手機聊天和電腦上的規劃是**兩條獨立的對話**

## 想在手機看完整規劃？用 GitHub 同步

規劃文件是會持續編輯的 markdown 檔，**只有 GitHub 能真的雙向同步**。Notion / iCloud / Apple Notes 那類雲端筆記只能做一次性快照、無法把手機修改回流到電腦，不適合當規劃工作流。

GitHub 你可以想成「會記錄每次變動的雲端空間」，免費註冊就有，[沒帳號到這註冊](https://github.com/signup)。

做法：

1. 在電腦上把旅行專案資料夾 push 到一個 GitHub private repo
2. 手機 Claude Code app（iOS / Android 支援者）選取該 GitHub repo 作為工作空間
3. 手機 Claude 就能讀取 / 編輯 `CLAUDE.md`、行程表、記帳檔等
4. 修改後 commit 回 GitHub，電腦端 pull 下來就是最新版本

好處：行程即時同步雙向編輯、記帳寫回檔案。代價：要熟悉 git workflow（push / pull / commit）。
