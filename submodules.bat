@echo off
setlocal enabledelayedexpansion

echo ========================================
echo [INFO] 開始批次加入 submodules
echo ========================================

REM === 1. 檢查設定檔是否存在 ===
if not exist submodules_config.txt (
    echo [ERROR] 找不到 submodules_config.txt，請先建立。
    pause
    exit /b
)

REM === 2. 開始讀取每一行 ===
for /f "tokens=1,2 delims= " %%a in (submodules_config.txt) do (
    set subPath=%%a
    set subURL=%%b

    if exist "!subPath!\" (
        echo [INFO] 子模組 !subPath! 已存在，略過新增。
    ) else (
        echo [INFO] 加入 submodule：!subPath!
        git submodule add !subURL! !subPath!
    )
)

REM === 3. 初始化並更新所有 submodules ===
echo [INFO] 初始化並更新所有 submodules...
git submodule init
git submodule update --remote --merge

echo ========================================
echo [完成] 所有 submodule 已處理完成。
echo ========================================
pause
