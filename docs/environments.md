# 在哪些環境可以使用？

不同環境支援度不同，先看表：

## 環境對照表

| 環境 | 個人 skills (~/.claude/skills/) | 專案 skills (專案/.claude/skills/) | 推薦做法 |
|------|------|------|------|
| 桌面 App（Mac / Windows） | ✓ | ✓ | 用[方法一](install.md#方法一)安裝到個人路徑 |
| 終端機 CLI | ✓ | ✓ | 用[方法一](install.md#方法一)或[方法四](install.md#方法四)安裝到個人路徑 |
| VS Code / JetBrains 擴充 | ✓ | ✓ | 跟桌面 App 一樣 |
| **claude.ai/code（網頁版）** | ✗ | ✓ | 必須 clone 到旅行專案資料夾，見下方 |
| claude.ai 一般對話 | ✓（透過 Settings → Customize 上傳） | — | 跟 Claude Code 是兩條獨立的對話 |

## 為什麼 claude.ai/code 用不到個人 skills？

claude.ai/code 跑在 Anthropic 雲端虛擬機，碰不到你電腦的 `~/.claude/`，只能讀打開的那個 GitHub repo 內的 `.claude/skills/`。要用 trip skills，得把它跟旅行專案一起 commit 上 GitHub。

## 在 claude.ai/code 使用 trip skills 的做法

> 📌 **要 GitHub 帳號。** 把它想成「會記錄變動的雲端空間」，免費註冊就有，不用會寫程式。[沒帳號？點這註冊](https://github.com/signup)。
>
> 完全不想碰 GitHub？這條路不適合你，請改用桌面 App 或 CLI（看[安裝指南](install.md)）。注意：規劃文件要在手機上看與編輯，目前**只能透過 GitHub 同步**，沒有其他可靠方案。

### 做法 A：把 skills 放進旅行專案（最直接）

1. 建一個 GitHub repo 當你的旅行專案資料夾（例如 `my-paris-trip`）
2. 在 repo 裡建 `.claude/skills/`，把 trip skills 複製進去：

   ```bash
   git clone https://github.com/fdjkgh580/claude-trip-skills.git /tmp/trip
   mkdir -p .claude/skills
   cp -r /tmp/trip/skills/trip-* .claude/skills/
   rm -rf /tmp/trip
   ```
3. commit 並 push 到 GitHub
4. 在 claude.ai/code 打開這個 repo，就能用 `/trip` 了

### 做法 B：用 git submodule（想之後追上游更新時）

```bash
cd my-paris-trip
git submodule add https://github.com/fdjkgh580/claude-trip-skills.git .claude/skills/claude-trip-skills
git commit -m "Add trip skills as submodule"
git push
```

之後想升級，`git submodule update --remote` 一行搞定。

> ⚠️ **submodule 路徑注意：**Claude Code 掃描 `.claude/skills/<skill-name>/SKILL.md`，submodule 進來路徑會多一層 `.claude/skills/claude-trip-skills/skills/trip-go/SKILL.md`。若 `/trip` 沒出現，改用做法 A。

## 載入時機（觀察）

> 使用者實測，**官方文件未明確說明**：第一次打開專案時 `/` 自動完成可能還沒掃到 trip skills，先打一句「hi」讓 Claude 載入上下文，再輸入 `/` 通常就出現。

→ 想了解手機怎麼用，看 [mobile.md](mobile.md)。
