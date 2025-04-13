@echo off
setlocal enabledelayedexpansion

echo ========================================
echo [INFO] �}�l�妸�[�J submodules
echo ========================================

REM === 1. �ˬd�]�w�ɬO�_�s�b ===
if not exist submodules_config.txt (
    echo [ERROR] �䤣�� submodules_config.txt�A�Х��إߡC
    pause
    exit /b
)

REM === 2. �}�lŪ���C�@�� ===
for /f "tokens=1,2 delims= " %%a in (submodules_config.txt) do (
    set subPath=%%a
    set subURL=%%b

    if exist "!subPath!\" (
        echo [INFO] �l�Ҳ� !subPath! �w�s�b�A���L�s�W�C
    ) else (
        echo [INFO] �[�J submodule�G!subPath!
        git submodule add !subURL! !subPath!
    )
)

REM === 3. ��l�ƨç�s�Ҧ� submodules ===
echo [INFO] ��l�ƨç�s�Ҧ� submodules...
git submodule init
git submodule update --remote --merge

echo ========================================
echo [����] �Ҧ� submodule �w�B�z�����C
echo ========================================
pause
