---
name: save
description: "把目前所有未儲存的旅行檔案變更一次存到雲端。給外行人用，全程不需要懂 git。當使用者說「儲存」「保存」「存到雲端」「commit」之類的詞，或看到「尚未儲存」提示時，主動建議跑這個。"
user-invocable: true
disable-model-invocation: true
---

# /save — 把旅行變更存到雲端

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

2. 執行（**全部依序**，不要跳步驟）：

   ```bash
   # 先把當前變更存到當前 branch
   git add -A
   git commit -m "<你寫的 commit message>"

   # 偵測當前 branch
   CURRENT=$(git rev-parse --abbrev-ref HEAD)

   if [ "$CURRENT" = "main" ] || [ "$CURRENT" = "master" ]; then
     # 已經在 main，直接 push
     git push origin "$CURRENT"
   else
     # 在 feature branch：先把 feature push 上去，然後切 main 合併再推
     git push origin "$CURRENT"
     git checkout main 2>/dev/null || git checkout master
     git pull origin HEAD
     git merge --no-ff "$CURRENT" -m "整合 $CURRENT 的變更"
     git push origin HEAD
     # 清掉 feature branch（本機 + 遠端）
     git branch -d "$CURRENT"
     git push origin --delete "$CURRENT"
   fi
   ```

3. 任一步失敗 → 告訴使用者「儲存遇到問題，{簡短說明，避免術語}」。例如 push 被擋就說「網路或權限有問題，稍後再試」。**不要暴露 git 指令、branch 名稱**。

4. 最終結果：使用者的工作目錄停在 `main`，所有變更都在 main 上、雲端也是。

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
