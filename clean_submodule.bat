@echo off
setlocal enabledelayedexpansion

echo ========================================
echo [�M�� Git submodule �O���u��]
echo ========================================

REM �ˬd�]�w�ɬO�_�s�b
if not exist submodules_config.txt (
    echo [ERROR] �䤣�� submodules_config.txt�A�Х��إߡI
    pause
    exit /b
)

REM �}�l�M���C�� submodule
for /f "tokens=1 delims= " %%a in (submodules_config.txt) do (
    set "subPath=%%a"
    echo ----------------------------------------
    echo [INFO] ���� submodule�G!subPath!

    git submodule deinit -f !subPath!
    git rm -f !subPath!
    if exist ".git\modules\!subPath!" (
        rmdir /s /q ".git\modules\!subPath!"
    )
)

REM �R�� .gitmodules �ɮ�
if exist .gitmodules (
    del .gitmodules
    echo [INFO] .gitmodules �ɮפw�R��
)

echo [INFO] �M�������A�Ф�ʰ��� git add/commit/push
echo ========================================
pause
