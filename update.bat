@echo off
setlocal enabledelayedexpansion
echo ========================================
echo [INFO] 開始處理主 Git 專案：%cd%
echo ========================================

REM ====== 主專案 upstream 設定 ======
git remote | findstr "upstream" > nul
IF ERRORLEVEL 1 (
    echo [INFO] 加入主專案 upstream...
    git remote add upstream https://github.com/google/A2A.git
) ELSE (
    echo [INFO] 主專案 upstream 已存在，略過。
)
git remote set-url --push upstream no_push

REM ====== 主專案更新 ======
echo [INFO] Fetch + Pull upstream/main ...
git fetch upstream
git pull upstream main --allow-unrelated-histories

REM ====== 確保設定檔存在 ======
if not exist submodules_config.txt (
    echo [ERROR] 找不到 submodules_config.txt，請先建立。
    pause
    exit /b
)

REM ====== 依設定檔新增 submodule（如果不存在） ======
echo [INFO] 檢查並加入尚未存在的 submodule...
for /f "tokens=1,2 delims= " %%a in (submodules_config.txt) do (
    set "subPath=%%a"
    set "subURL=%%b"

    if exist "!subPath!\" (
        echo [INFO] !subPath! 已存在，略過新增。
    ) else (
        echo [INFO] 新增 submodule：!subPath!
        git submodule add !subURL! !subPath!
    )
)

REM ====== 初始化 submodules ======
echo [INFO] 初始化 submodules...
git submodule init
git submodule update

REM ====== 更新每一個 submodule 並設 upstream ======
for /f "tokens=1,2 delims= " %%a in (submodules_config.txt) do (
    set "subPath=%%a"
    set "subURL=%%b"

    echo ----------------------------------------
    echo [INFO] 處理 submodule：!subPath!

    if not exist "!subPath!\" (
        echo [WARNING] 路徑 !subPath! 不存在，略過。
        goto :continueLoop
    )

    pushd "!subPath!" > nul

    REM 確保進入的確實是 git repo
    if exist .git (
        git remote | findstr "upstream" > nul
        IF ERRORLEVEL 1 (
            echo [INFO] 設定 submodule upstream：!subURL!
            git remote add upstream !subURL!
        ) ELSE (
            echo [INFO] upstream 已存在，略過設定。
        )
        git remote set-url --push upstream no_push

        echo [INFO] 更新 submodule 內容...
        git checkout main
        git fetch upstream
        git pull upstream main
    ) ELSE (
        echo [ERROR] !subPath! 不是有效的 git repo，請檢查初始化。
    )

    popd > nul
    :continueLoop
)

REM ====== 回主專案提交 submodule 變更 ======
echo [INFO] 提交 submodule 指標更新...
git add .
git commit -m "同步主專案與所有 submodule"
git push origin main

echo ========================================
echo [完成] 所有 submodule 已更新並推送至 origin
echo ========================================
pause
