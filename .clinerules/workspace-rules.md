# Google ADK 專案 Workspace Rules

## 1. 專案結構與目錄規範
- 主程式碼放置於 `src/` 或指定子目錄，範例置於 `adk-samples/`，測試代碼置於 `tests/`。
- 文件資源置於 `adk-docs/`，靜態資產置於 `assets/`。
- 目錄與檔案命名採用小寫字母與底線分隔，避免空格與特殊字元。

## 2. Python 虛擬環境與依賴管理
- 建立虛擬環境指令：
  ```bash
  python -m venv .venv
  ```
- 啟用虛擬環境：
  - Windows PowerShell：
    ```
    .venv\Scripts\Activate.ps1
    ```
  - Windows CMD：
    ```
    .venv\Scripts\activate.bat
    ```
  - macOS/Linux：
    ```
    source .venv/bin/activate
    ```
- 依賴安裝：
  ```bash
  pip install google-adk
  ```
- 依賴管理請使用 `requirements.txt` 或 `pyproject.toml`，避免直接修改系統環境。

## 3. 開發流程與工具
- 啟動 ADK 開發介面：
  ```bash
  adk web
  ```
- 執行代理程式：
  ```bash
  adk run <agent_project>
  ```
- 啟動 API 伺服器：
  ```bash
  adk api_server
  ```
- 執行單元測試與評估：
  ```bash
  adk eval <agent_project> <eval_set>
  ```
- 文件預覽：
  ```bash
  mkdocs serve
  ```

## 4. 版本控制與協作
- 使用 Git 進行版本控制，所有修改需透過 Pull Request 審查。
- 分支命名建議：
  - 功能開發：`feature/<描述>`
  - 修正錯誤：`bugfix/<描述>`
  - 緊急修復：`hotfix/<描述>`
- Commit message 建議遵循 Conventional Commits 格式。

## 5. 代碼風格與品質
- 使用 pylint、black、flake8 等工具維持代碼品質。
- 代碼格式化與靜態檢查為開發流程必備步驟。
- 變數與常數統一由配置文件管理，嚴禁重複定義。

## 6. 憑證與敏感資訊管理
- 憑證快取與管理請使用 `tool_context.state`，避免硬編碼。
- 禁止將敏感資訊提交至版本庫。

## 7. Google CLA 與社群規範
- 所有貢獻者必須簽署 Google Contributor License Agreement (CLA)。
- 遵守 Google 開源社群行為準則。

## 8. 其他最佳實踐
- 讀寫文字檔案時，請使用 `encoding="utf-8"`，確保繁體中文友好。
- 新功能或影響原有操作的修改，必須於 `README.md` 合適位置同步更新說明與使用方法。
- 專案中禁止使用 `&&` 操作符，因 Windows 環境不支援。

---

## 9. 範例程式碼示範

### 範例 1：克隆並進入範例專案目錄
```bash
git clone https://github.com/google/adk-samples.git
cd adk-samples/agents/brand-search-optimization
```

### 範例 2：使用 Poetry 安裝依賴並啟動虛擬環境
```bash
pip install poetry
poetry install
poetry env activate
```

### 範例 3：設定環境變數（以 Bash 為例）
```bash
export GOOGLE_GENAI_USE_VERTEXAI=1
export GOOGLE_CLOUD_PROJECT='YOUR_VALUE_HERE'
export GOOGLE_CLOUD_LOCATION='YOUR_VALUE_HERE'
export BQ_PROJECT_ID='YOUR-BQ-PROJECT-ID'
export BQ_DATASET_ID='YOUR-DATASET-ID'
export CODE_INTERPRETER_EXTENSION_NAME='projects/<YOUR_PROJECT_ID>/locations/us-central1/extensions/<YOUR_EXTENSION_ID>'
```

### 範例 4：使用 Python 與 Vertex AI Agent Engine 互動
```python
from vertexai import agent_engines

remote_agent = vertexai.agent_engines.get(RESOURCE_ID)
session = remote_agent.create_session(user_id=USER_ID)
while True:
    user_input = input("Input: ")
    if user_input == "quit":
        break

    for event in remote_agent.stream_query(
        user_id=USER_ID,
        session_id=session["id"],
        message=user_input,
    ):
        parts = event["content"]["parts"]
        for part in parts:
            if "text" in part:
                print(part["text"])
```

---

以上為 Google ADK 專案的 Workspace Rules，請依此規範進行開發與協作。
