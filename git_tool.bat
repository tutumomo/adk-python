@echo off
setlocal enabledelayedexpansion

:menu
echo ========================================
echo [���] Git �ާ@���
echo ========================================
echo [0] ���s�˾���l�ơ]��ĳ�b�s�q���W�Ĥ@���ާ@�Ρ^
echo [1] ��l�� submodules�]�t�ˬd�O�_�w��l�ơ^
echo [2] �q�W�� repo ��s�]�t submodules�^
echo [3] ���e�� GitHub�]�t submodules�^
echo [X] ���}
echo ========================================
set /p choice=�п�J�ﶵ�s���G

if /I "!choice!"=="0" goto fullinit
if /I "!choice!"=="1" goto init
if /I "!choice!"=="2" goto pull
if /I "!choice!"=="3" goto push
if /I "!choice!"=="X" goto end
goto menu

:fullinit
set /p "repoURL=�п�J GitHub repo URL�]�Ҧp https://github.com/�A/adk-python.git�^: "
git clone --recurse-submodules !repoURL!
cd adk-python
git submodule update --init --recursive
echo [INFO] �w clone �ê�l�� submodules

git remote | findstr "upstream" > nul
IF ERRORLEVEL 1 (
    set /p upstreamURL=�п�J�D�M�ת� upstream URL:
    git remote add upstream !upstreamURL!
)

echo [INFO] ��l�Ƨ����A�w��ϥ�
pause
goto end

:init
set "needInit=1"

if exist .gitmodules (
    echo [INFO] ������ .gitmodules �s�b�C
    for /f %%i in ('findstr /i "\[submodule" .gitmodules') do (
        set "needInit=0"
    )
)

if "!needInit!"=="0" (
    set /p redoInit=[INFO] �˴���w�� submodules �O���A�O�_���s��l�ơH(Y/N):
    if /I "!redoInit!" NEQ "Y" (
        echo [INFO] �w������l�� submodules�C
        goto menu
    )
)

if exist submodules_config.txt (
    echo [INFO] �}�l�� submodules_config.txt ��l�� submodules...
    for /f "tokens=1,2,3 delims= " %%a in (submodules_config.txt) do (
        if not exist "%%a\\" (
            git submodule add %%b %%a
        )
    )
    git submodule init
    git submodule update --remote --merge
    echo [INFO] Submodules ��l�Ƨ���
) else (
    echo [INFO] �������� submodules_config.txt�A���L submodule ��l��
)
goto menu

:pull
echo [INFO] ��s�D�M��...
git remote | findstr "upstream" > nul
IF ERRORLEVEL 1 (
    set /p upstreamURL=�п�J�D�M�ת� upstream URL:
    git remote add upstream !upstreamURL!
)
git fetch upstream
git pull upstream main --allow-unrelated-histories

if exist submodules_config.txt (
    echo [INFO] �}�l��s submodules�]�q upstream �Ԩ��^
    for /f "tokens=1,2,3 delims= " %%a in (submodules_config.txt) do (
        set "subPath=%%a"
        set "originURL=%%b"
        set "upstreamURL=%%c"
        if exist "!subPath!\\" (
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
goto menu

:push
set "defaultMsg=��s"
set /p "commitMsg=�п�J commit �T���]������ Enter �h�ϥιw�]�G"��s"�^: "
if "!commitMsg!"=="" (
    set commitMsg=!defaultMsg!
)

for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
    set today=%%a-%%b-%%c
)
for /f "tokens=1-2 delims=: " %%x in ('time /t') do (
    set now=%%x_%%y
)
set timestamp=!today!_!now!

echo Commit Log - !timestamp! > commit_log.txt
echo -------------------------- >> commit_log.txt

if exist submodules_config.txt (
    echo [INFO] �}�l���e submodules...
    for /f "tokens=1,2,3 delims= " %%a in (submodules_config.txt) do (
        set "subPath=%%a"
        set "originURL=%%b"
        set "upstreamURL=%%c"
        if exist "!subPath!\\" (
            pushd "!subPath!" > nul
            git add .
            git commit -m "!commitMsg! - !timestamp!" 2>nul
            git push origin main
            echo [submodule] %%a ���榨�\�G!commitMsg! - !timestamp! >> ..\\commit_log.txt
            popd > nul
        )
    )
)

echo [INFO] ����D�M��
git add .
git commit -m "!commitMsg! - !timestamp!" 2>nul
git push origin main
echo [main] �D�M�״��榨�\�G!commitMsg! - !timestamp! >> commit_log.txt

goto menu

:end
echo.
echo �@�~�����A�w��U���A�ΡI
pause
