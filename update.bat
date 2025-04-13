@echo off
setlocal enabledelayedexpansion
echo ========================================
echo [INFO] �}�l�B�z�D Git �M�סG%cd%
echo ========================================

REM ====== �D�M�� upstream �]�w ======
git remote | findstr "upstream" > nul
IF ERRORLEVEL 1 (
    echo [INFO] �[�J�D�M�� upstream...
    git remote add upstream https://github.com/google/A2A.git
) ELSE (
    echo [INFO] �D�M�� upstream �w�s�b�A���L�C
)
git remote set-url --push upstream no_push

REM ====== �D�M�ק�s ======
echo [INFO] Fetch + Pull upstream/main ...
git fetch upstream
git pull upstream main --allow-unrelated-histories

REM ====== �T�O�]�w�ɦs�b ======
if not exist submodules_config.txt (
    echo [ERROR] �䤣�� submodules_config.txt�A�Х��إߡC
    pause
    exit /b
)

REM ====== �̳]�w�ɷs�W submodule�]�p�G���s�b�^ ======
echo [INFO] �ˬd�å[�J�|���s�b�� submodule...
for /f "tokens=1,2 delims= " %%a in (submodules_config.txt) do (
    set "subPath=%%a"
    set "subURL=%%b"

    if exist "!subPath!\" (
        echo [INFO] !subPath! �w�s�b�A���L�s�W�C
    ) else (
        echo [INFO] �s�W submodule�G!subPath!
        git submodule add !subURL! !subPath!
    )
)

REM ====== ��l�� submodules ======
echo [INFO] ��l�� submodules...
git submodule init
git submodule update

REM ====== ��s�C�@�� submodule �ó] upstream ======
for /f "tokens=1,2 delims= " %%a in (submodules_config.txt) do (
    set "subPath=%%a"
    set "subURL=%%b"

    echo ----------------------------------------
    echo [INFO] �B�z submodule�G!subPath!

    if not exist "!subPath!\" (
        echo [WARNING] ���| !subPath! ���s�b�A���L�C
        goto :continueLoop
    )

    pushd "!subPath!" > nul

    REM �T�O�i�J���T��O git repo
    if exist .git (
        git remote | findstr "upstream" > nul
        IF ERRORLEVEL 1 (
            echo [INFO] �]�w submodule upstream�G!subURL!
            git remote add upstream !subURL!
        ) ELSE (
            echo [INFO] upstream �w�s�b�A���L�]�w�C
        )
        git remote set-url --push upstream no_push

        echo [INFO] ��s submodule ���e...
        git checkout main
        git fetch upstream
        git pull upstream main
    ) ELSE (
        echo [ERROR] !subPath! ���O���Ī� git repo�A���ˬd��l�ơC
    )

    popd > nul
    :continueLoop
)

REM ====== �^�D�M�״��� submodule �ܧ� ======
echo [INFO] ���� submodule ���Ч�s...
git add .
git commit -m "�P�B�D�M�׻P�Ҧ� submodule"
git push origin main

echo ========================================
echo [����] �Ҧ� submodule �w��s�ñ��e�� origin
echo ========================================
pause
