@echo off
setlocal enabledelayedexpansion

REM === commit message 互動輸入 ===
set "defaultMsg=更新"
set /p "commitMsg=請輸入 commit 訊息（直接按 Enter 則使用預設："更新"）: "
if "!commitMsg!"=="" (
    set commitMsg=!defaultMsg!
)

REM === 加上時間戳 ===
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
    set today=%%a-%%b-%%c
)
for /f "tokens=1-2 delims=: " %%x in ('time /t') do (
    set now=%%x_%%y
)
set timestamp=!today!_!now!

REM === 建立 commit log 檔 ===
echo Commit Log - !timestamp! > commit_log.txt
echo -------------------------- >> commit_log.txt

echo ========================================
echo [選單] Git 操作選擇
echo ========================================
echo [1] 初始化 submodules
echo [2] 從上游 repo 更新（含 submodules）
echo [3] 推送到 GitHub（含 submodules）
echo [0] 離開
echo ========================================
set /p choice=請輸入選項編號：

if "!choice!"=="1" goto init
if "!choice!"=="2" goto pull
if "!choice!"=="3" goto push
goto end

:init
if exist submodules_config.txt (
    echo [INFO] 偵測到 submodules_config.txt，開始加入 submodules...
    for /f "tokens=1,2,3 delims= " %%a in (submodules_config.txt) do (
        if not exist "%%a\" (
            git submodule add %%b %%a
        )
    )
    git submodule init
    git submodule update --remote --merge
    echo [INFO] Submodules 初始化完成
) else (
    echo [INFO] 未偵測到 submodules_config.txt，略過 submodule 初始化
)
goto end

:pull
echo [INFO] 更新主專案...
git remote | findstr "upstream" > nul
IF ERRORLEVEL 1 (
    set /p upstreamURL=請輸入主專案的 upstream URL:
    git remote add upstream !upstreamURL!
)
git fetch upstream
git pull upstream main --allow-unrelated-histories

if exist submodules_config.txt (
    echo [INFO] 開始更新 submodules（從 upstream 拉取）
    for /f "tokens=1,2,3 delims= " %%a in (submodules_config.txt) do (
        set "subPath=%%a"
        set "originURL=%%b"
        set "upstreamURL=%%c"
        if exist "!subPath!\" (
            pushd "!subPath!" > nul
            git remote set-url origin !originURL!
            git remote | findstr "upstream" > nul
            if ERRORLEVEL 1 (
                git remote add upstream !upstreamURL!
            ) else (
                git remote set-url upstream !upstreamURL!
            )
            git checkout main
            git fetch upstream
            git pull upstream main
            popd > nul
        )
    )
)
goto end

:push
if exist submodules_config.txt (
    echo [INFO] 開始推送 submodules...
    for /f "tokens=1,2,3 delims= " %%a in (submodules_config.txt) do (
        set "subPath=%%a"
        set "originURL=%%b"
        set "upstreamURL=%%c"
        if exist "!subPath!\" (
            pushd "!subPath!" > nul
            git add .
            git commit -m "!commitMsg! - !timestamp!" 2>nul
            git push origin main
            echo [submodule] %%a 提交成功：!commitMsg! - !timestamp! >> ..\commit_log.txt
            popd > nul
        )
    )
)

echo [INFO] 提交主專案
git add .
git commit -m "!commitMsg! - !timestamp!" 2>nul
git push origin main
echo [main] 主專案提交成功：!commitMsg! - !timestamp! >> commit_log.txt
goto end

:end
echo.
echo 操作已完成，詳見 commit_log.txt
pause
