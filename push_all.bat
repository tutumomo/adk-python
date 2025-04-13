@echo off
setlocal enabledelayedexpansion

echo ========================================
echo [INFO] �}�l���e�Ҧ� submodule + �D�M��
echo ========================================

REM === �ˬd�]�w�� ===
if not exist submodules_config.txt (
    echo [ERROR] �䤣�� submodules_config.txt�A�Х��إߡC
    pause
    exit /b
)

REM === �B�z�C�� submodule ===
for /f "tokens=1,2 delims= " %%a in (submodules_config.txt) do (
    set "subPath=%%a"
    set "subURL=%%b"

    echo ----------------------------------------
    echo [INFO] �B�z submodule�G!subPath!

    if exist "!subPath!\" (
        pushd "!subPath!" > nul

        if exist .git (
            git status
            git add .
            git commit -m "���a�ק�G��s submodule !subPath!" 2>nul
            git push origin main
        ) else (
            echo [ERROR] !subPath! ���O���Ī� Git repo�A���ˬd�C
        )

        popd > nul
    ) else (
        echo [WARNING] ��Ƨ� !subPath! ���s�b�A���L�C
    )
)

REM === �^��D�M�׳B�z submodule �����ܧ� ===
echo ----------------------------------------
echo [INFO] ����D�M�פ��� submodule �����ܧ�
git add .
git commit -m "��s submodule ����" 2>nul
git push origin main

echo ========================================
echo [����] �Ҧ� submodule �ΥD�M�׳��w���\���e
echo ========================================
pause
