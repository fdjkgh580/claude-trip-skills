---
name: backup
description: "把目前所有未儲存的旅行檔案變更一次存到雲端（commit + push + merge to main）。**只在使用者明確說『儲存』『保存』『存到雲端』『commit』『存起來』『備份』『上傳』時觸發**，或是使用者看到「尚未儲存」提示後主動要求儲存時觸發。**不要在 Claude 自己寫完檔後主動呼叫**（那樣會煩到使用者）。給外行人用，全程不需要懂 git。"
user-invocable: true
---

# /backup — 把旅行變更存到雲端

使用與使用者相同的語言回覆（預設繁體中文）。

對 trip 規劃使用者來說，雲端 sandbox 是短暫的，session 結束未存的變更就消失。這個 skill 把所有變更一次存到雲端 GitHub repo。

## 措辭規則（重要）

**只用這些詞**：儲存、雲端、變更、檔案
**禁用**：commit、push、merge、branch、staging、stash、HEAD、origin、main、master

99% 使用者不是工程師。看到 git 術語會立刻迷失。

## 流程

### 1. 檢查有沒有變更

```bash
git status --porcelain
```

**沒輸出（無變更）** → 直接告訴使用者「目前沒有需要儲存的變更 ✓」，結束。

**有輸出** → 進入步驟 2。

### 2. 列出變更給使用者看 + 確認

用 `git status --porcelain` 的輸出整理成簡短中文描述，例如：

> 你有以下變更還沒儲存：
> - 行程表
> - 記帳檔（加 3 筆花費）
> - 研究報告（attractions、food）

接著用 `AskUserQuestion` 問：

- 問題：「確定全部存到雲端嗎？」
- 選項 1：「好，存」（Recommended）
- 選項 2：「先不要，我再看一下」

### 3. 寫 commit message + 推上去 + 整理到主線

使用者選「好」後：

1. 看 `git diff --cached` 與 `git diff`（含未 staged 的）內容，**自己寫一段簡短中文 commit message** 描述這次主要變動。例如：
   - 「加入記帳：午餐 25 歐元、地鐵票 14 歐元」
   - 「更新第 3 天行程：博物館改下午」
   - 「研究報告：景點與美食」
   - 變動雜時用「更新旅行檔案」當保底

2. 執行（**全部依序**，不要跳步驟）。**重要**：必須拆成多個獨立的 bash 呼叫，**不要用 `&&` 把全部串成一行**，否則一個失敗就看不出哪步出錯，而且最後的 cleanup 失敗會把整個任務標記成失敗。

   **Step A — 存當前變更**：
   ```bash
   git add -A && git commit -m "<你寫的 commit message>"
   ```

   **Step B — 偵測 branch 並決定路線**：
   ```bash
   git rev-parse --abbrev-ref HEAD
   ```

   **如果輸出是 `main` 或 `master`**：直接推上去
   ```bash
   git push origin HEAD
   ```
   完成，跳到下面「成功回報」。

   **否則（在 feature branch，記下名字 `<CUR>`）**：以下每一步**獨立呼叫**：

   B1. 推 feature branch（讓雲端先有備份）：
   ```bash
   git push origin <CUR>
   ```

   B2. 切到主線：
   ```bash
   git checkout main 2>/dev/null || git checkout master
   ```

   B3. 拉最新主線：
   ```bash
   git pull origin HEAD
   ```

   B4. **把 feature 合併進主線**（這是關鍵步驟，失敗要中止並回報）：
   ```bash
   git merge --no-ff <CUR> -m "整合 <CUR> 的變更"
   ```

   B5. **推主線**（這也是關鍵步驟，失敗要中止並回報）：
   ```bash
   git push origin HEAD
   ```

   ⬆️ **到 B5 為止，使用者資料已經安全在雲端 main 上**。下面 B6 / B7 只是清理，**失敗也不要回報失敗、不要顯示錯誤訊息給使用者**，靜默跳過即可。

   B6. 刪本機 feature branch（best-effort）：
   ```bash
   git branch -d <CUR> 2>/dev/null || true
   ```

   B7. 刪遠端 feature branch（best-effort，sandbox 的 git proxy 常回 403，**不算錯**）：
   ```bash
   git push origin --delete <CUR> 2>/dev/null || true
   ```

3. **失敗判斷規則**：
   - **Step A / B4 / B5 任一失敗** → 告訴使用者「儲存遇到問題，{簡短說明，避免術語}」。**不要暴露 git 指令、branch 名稱**。
   - **B1 / B6 / B7 失敗** → 靜默忽略，使用者不需要知道。資料已經在 main 上了。

4. 最終結果：使用者的工作目錄停在 `main`，所有變更都在 main 上、雲端也是。GitHub 上可能殘留孤兒 feature branch（B7 失敗時），這不影響使用者，**不要主動提**。

### 4. 成功回報

```
✓ 已儲存到雲端

剛剛的變更全部存好了，現在關掉視窗也不會不見。
```

## 不要做的事

- 不要分多個 commit。一次儲存 = 一次 commit。
- 不要解釋 git 流程給使用者。
- 不要問使用者「commit message 要寫什麼」— 自己決定。
- 不要在使用者沒選「好」前就執行 git add / commit / push。
