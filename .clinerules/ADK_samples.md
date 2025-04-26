# Google ADK 範例程式碼彙整

## Clone and Navigate to Repository
```bash
# Clone this repository.
git clone https://github.com/google/adk-samples.git
cd adk-samples/agents/brand-search-optimization
```
_說明：克隆 adk-samples 倉庫並進入範例目錄。_

## Authentication with Google Cloud
```bash
gcloud auth application-default login
```
_說明：使用 Google Cloud 預設憑證登入，取得資源存取權限。_

## Installing dependencies with Poetry
```bash
pip install poetry
poetry install
poetry env activate
```
_說明：安裝 Poetry 並建立虛擬環境，安裝專案依賴。_

## Setting Environment Variables for Agent Configuration in Bash
```bash
# Choose Model Backend: 0 -> ML Dev, 1 -> Vertex
GOOGLE_GENAI_USE_VERTEXAI=1

# ML Dev backend config. Fill if using Ml Dev backend.
GOOGLE_API_KEY='YOUR_VALUE_HERE'

# Vertex backend config
GOOGLE_CLOUD_PROJECT='YOUR_VALUE_HERE'
GOOGLE_CLOUD_LOCATION='YOUR_VALUE_HERE'
```
```bash
export BQ_PROJECT_ID='YOUR-BQ-PROJECT-ID'
export BQ_DATASET_ID='YOUR-DATASET-ID' # leave as 'forecasting_sticker_sales' if using sample data
```
```bash
export CODE_INTERPRETER_EXTENSION_NAME='projects/<YOUR_PROJECT_ID>/locations/us-central1/extensions/<YOUR_EXTENSION_ID>'
```
_說明：設定多項環境變數以配置代理運行環境。_

## Cloning and Setup Using Git and Poetry in Bash
```bash
git clone https://github.com/google/adk-samples.git
cd adk-samples/agents/data-science
```
```bash
poetry install
```
```bash
poetry env activate

# Alternative activation method if above does not work
source .venv/bin/activate
```
_說明：克隆資料科學代理範例並安裝依賴。_

## Configuring Environment Variables (.env) - Bash
```bash
# Choose Model Backend: 0 -> ML Dev, 1 -> Vertex
GOOGLE_GENAI_USE_VERTEXAI=1
# ML Dev backend config, when GOOGLE_GENAI_USE_VERTEXAI=0, ignore if using Vertex.
# GOOGLE_API_KEY=YOUR_VALUE_HERE

# Vertex backend config
GOOGLE_CLOUD_PROJECT=__YOUR_CLOUD_PROJECT_ID__
GOOGLE_CLOUD_LOCATION=us-central1

# Places API
GOOGLE_PLACES_API_KEY=__YOUR_API_KEY_HERE__

# GCS Storage Bucket name - for Agent Engine deployment test
GOOGLE_CLOUD_STORAGE_BUCKET=YOUR_BUCKET_NAME_HERE

# Sample Scenario Path - Default is an empty itinerary
# This will be loaded upon first user interaction.
#
# Uncomment one of the two, or create your own.
#
# TRAVEL_CONCIERGE_SCENARIO=eval/itinerary_seattle_example.json
TRAVEL_CONCIERGE_SCENARIO=eval/itinerary_empty_default.json
```
_說明：旅行代理範例的環境變數設定範例。_

## Receiving Flight Seat Map Data JSON
```json
{
  "seats": [
    [
      {"isAvailable": true, "priceInUSD": 60, "seatNumber": "1A"},
      {"isAvailable": true, "priceInUSD": 60, "seatNumber": "1B"},
      {"isAvailable": false, "priceInUSD": 60, "seatNumber": "1C"},
      {"isAvailable": true, "priceInUSD": 70, "seatNumber": "1D"},
      {"isAvailable": true, "priceInUSD": 70, "seatNumber": "1E"},
      {"isAvailable": true, "priceInUSD": 50, "seatNumber": "1F"}
    ],
    [
      {"isAvailable": true, "priceInUSD": 60, "seatNumber": "2A"},
      {"isAvailable": false, "priceInUSD": 60, "seatNumber": "2B"},
      {"isAvailable": true, "priceInUSD": 60, "seatNumber": "2C"},
      {"isAvailable": true, "priceInUSD": 70, "seatNumber": "2D"},
      {"isAvailable": true, "priceInUSD": 70, "seatNumber": "2E"},
      {"isAvailable": true, "priceInUSD": 50, "seatNumber": "2F"}
    ]
  ]
}
```
_說明：航班座位圖的 JSON 範例資料。_

## Deploy Agent to Vertex AI
```bash
python deployment/deploy.py --create
```
_說明：部署代理至 Vertex AI Agent Engine。_

## Interacting with Agent Engine via Streaming Query (Python)
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
                text_part = part["text"]
                print(f"Response: {text_part}")
```
_說明：Python 程式碼示範如何與 Vertex AI 代理進行串流互動。_

## Creating Itinerary Using Itinerary Agent Function (JSON)
```json
{
  "function_call": "itinerary_agent",
  "args": {
    "request": "Origin: San Diego, CA, USA; Destination: Peru; Start Date: 2025-05-04; End Date: 2025-05-11; Outbound Flight: American Airlines (AA123) from SAN to LIM on 2025-05-04, Seat 1A; Return Flight: LATAM Airlines (LATAM2345) from LIM to SAN on 2025-05-11, Seat 2A; Hotel: Belmond Hotel Monasterio in Cusco, Peru; Room: Queen Room with Balcony; Day 1: Depart from home and fly to Lima; Day 2: Arrive in Lima, connecting flight to Cusco, check into hotel; Day 3: Explore Cusco; Day 4: Machu Picchu; Day 5: Vegan Food in Cusco; Day 6: Lake Titicaca; Day 7: Travel back to Lima; Day 8: Depart from Lima; Day 9: Arrive in San Diego."
  }
}
```
_說明：行程代理函數呼叫的 JSON 範例。_

## Run Unit Tests
```bash
sh deployment/test.sh
```
_說明：執行單元測試腳本。_

## Adding IAM Policy with bq Tool
```bash
bq add-iam-policy --member=user:user@example.com --role=roles/bigquery.dataViewer your-project-id:your_dataset_id.products
```
_說明：使用 bq 工具新增 BigQuery IAM 權限範例。_
