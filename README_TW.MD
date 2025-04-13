# Agent Development Kit (ADK)

[![授權條款](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Python 單元測試](https://github.com/google/adk-python/actions/workflows/python-unit-tests.yml/badge.svg)](https://github.com/google/adk-python/actions/workflows/python-unit-tests.yml)
[![r/agentdevelopmentkit](https://img.shields.io/badge/Reddit-r%2Fagentdevelopmentkit-FF4500?style=flat&logo=reddit&logoColor=white)](https://www.reddit.com/r/agentdevelopmentkit/)

<html>
    <h1 align="center">
      <img src="assets/agent-development-kit.png" width="256"/>
    </h1>
    <h3 align="center">
      一個開源、程式碼優先的 Python 工具包，用於彈性且可控地建構、評估和部署複雜的 AI 代理程式。
    </h3>
    <h3 align="center">
      重要連結：
      <a href="https://google.github.io/adk-docs/">文件</a> &
      <a href="https://github.com/google/adk-samples">範例</a>。
    </h3>
</html>

Agent Development Kit (ADK) 專為尋求精細控制和彈性的開發人員設計，用於建構與 Google Cloud 服務緊密整合的進階 AI 代理程式。它允許您直接在程式碼中定義代理程式行為、協調和工具使用，從而實現穩健的偵錯、版本控制和隨處部署——從您的筆記型電腦到雲端。


---

## ✨ 主要功能

- **豐富的工具生態系統**：利用預先建構的工具、自訂函式、OpenAPI 規格或整合現有工具，賦予代理程式多樣化的能力，所有這些都是為了與 Google 生態系統緊密整合。

- **程式碼優先開發**：直接在 Python 中定義代理程式邏輯、工具和協調，以實現極致的彈性、可測試性和版本控制。

- **模組化多代理程式系統**：透過將多個專業代理程式組合成彈性的層級結構來設計可擴展的應用程式。

- **隨處部署**：輕鬆將代理程式容器化並部署到 Cloud Run，或透過 Vertex AI Agent Engine 無縫擴展。


## 🚀 安裝

您可以使用 `pip` 安裝 ADK：

```bash
pip install google-adk
```
## 📚 文件

探索完整文件以取得有關建構、評估和部署代理程式的詳細指南：

* **[文件](https://google.github.io/adk-docs)**

## 🏁 功能亮點

### 定義單一代理程式：
```python
from google.adk.agents import Agent
from google.adk.tools import google_search

root_agent = Agent(
    name="search_assistant",
    model="gemini-2.0-flash", # 或您偏好的 Gemini 模型
    instruction="您是一位樂於助人的助理。在需要時使用 Google 搜尋回答使用者問題。",
    description="一個可以搜尋網路的助理。",
    tools=[google_search]
)
```

### 定義多代理程式系統：
定義一個包含協調者代理程式、問候者代理程式和任務執行代理程式的多代理程式系統。然後 ADK 引擎和模型將引導代理程式協同工作以完成任務。
```python
from google.adk.agents import LlmAgent, BaseAgent

# 定義個別代理程式
greeter = LlmAgent(name="Greeter", model="gemini-2.0-flash")
task_exectuor = CustomAgent(name="TaskExecutor") # BaseAgent 的子類別，作為非 LLM 代理程式。

# 建立父代理程式並透過 sub_agents 指派子代理程式
coordinator = LlmAgent(
    name="Coordinator",
    model="gemini-2.0-flash",
    description="我協調問候和任務。",
    sub_agents=[ # 在此處指派 sub_agents
        greeter,
        task_exectuor
    ]
)

```

### 開發 UI

內建的開發 UI 可協助您測試、評估、偵錯和展示您的代理程式。

<img src="assets/adk-web-dev-ui-function-call.png"/>

###  評估代理程式

```bash
adk eval \
    samples_for_testing/hello_world \
    samples_for_testing/hello_world/hello_world_eval_set_001.evalset.json
```


## 🤝 貢獻

我們歡迎社群的貢獻！無論是錯誤回報、功能請求、文件改進或程式碼貢獻，請參閱我們的 [**貢獻指南**](./CONTRIBUTING.md) 開始。

## 📄 授權條款

本專案採用 Apache 2.0 授權條款 - 詳情請參閱 [LICENSE](LICENSE) 檔案。

## 預覽

此功能受 [服務特定條款](https://cloud.google.com/terms/service-terms#1) 中一般服務條款部分的「預先發布版產品條款」約束。預先發布版功能「按原樣」提供，且可能支援有限。如需詳細資訊，請參閱 [發布階段說明](https://cloud.google.com/products?hl=en#product-launch-stages)。

---

*祝您建構代理程式愉快！*