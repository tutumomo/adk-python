@echo off
setlocal enabledelayedexpansion

echo ========================================
echo [INFO] 開始推送所有 submodule + 主專案
echo ========================================

REM === 檢查設定檔 ===
if not exist submodules_config.txt (
    echo [ERROR] 找不到 submodules_config.txt，請先建立。
    pause
    exit /b
)

REM === 處理每個 submodule ===
for /f "tokens=1,2 delims= " %%a in (submodules_config.txt) do (
    set "subPath=%%a"
    set "subURL=%%b"

    echo ----------------------------------------
    echo [INFO] 處理 submodule：!subPath!

    if exist "!subPath!\" (
        pushd "!subPath!" > nul

        if exist .git (
            git status
            git add .
            git commit -m "本地修改：更新 submodule !subPath!" 2>nul
            git push origin main
        ) else (
            echo [ERROR] !subPath! 不是有效的 Git repo，請檢查。
        )

        popd > nul
    ) else (
        echo [WARNING] 資料夾 !subPath! 不存在，略過。
    )
)

REM === 回到主專案處理 submodule 指標變更 ===
echo ----------------------------------------
echo [INFO] 提交主專案中的 submodule 指標變更
git add .
git commit -m "更新 submodule 指標" 2>nul
git push origin main

echo ========================================
echo [完成] 所有 submodule 及主專案都已成功推送
echo ========================================
pause
