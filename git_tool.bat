@echo off
setlocal enabledelayedexpansion

:menu
echo ========================================
echo [���] Git �ާ@���
echo ========================================
echo [0] ��l�ƥD�M�� remote �P submodules�]���a�w clone�^
echo [1] ��l�� submodules�]�t�ˬd�O�_�w��l�ơ^
echo [2] �q�W�� repo ��s�]upstream�^�]�t submodules�^
echo [3] ���e���a�ܧ�� GitHub�]origin�^�]�t submodules�^
echo [4] �q GitHub�]origin�^��s fork �M�ר쥻�a�ݡ]�t submodules�^
echo [X] ���}
echo ========================================
set /p choice=�п�J�ﶵ�s���G

if /I "!choice!"=="0" goto fullinit
if /I "!choice!"=="1" goto init
if /I "!choice!"=="2" goto pull_upstream
if /I "!choice!"=="3" goto push
if /I "!choice!"=="4" goto pull_from_origin
if /I "!choice!"=="X" goto end
goto menu

:fullinit
echo [INFO] �]�w�D repo �� upstream �ӷ�...
git remote | findstr "upstream" > nul
IF ERRORLEVEL 1 (
    set /p upstreamURL=�п�J�D�M�ת� upstream URL:
    git remote add upstream !upstreamURL!
) else (
    echo [INFO] upstream �w�s�b�A���L�]�w�C
)

echo [INFO] �ˬd�O�_�� submodules_config.txt...
if exist submodules_config.txt (
    echo [INFO] �}�l��l�� submodules...
    for /f "tokens=1,2,3 delims= " %%A in (submodules_config.txt) do (
        call :submodule_init_line "%%A" "%%B" "%%C"
    )
    git submodule init
    git submodule update --remote --merge
    echo [INFO] Submodules ��l�Ƨ���
) else (
    echo [INFO] �S�� submodules_config.txt�A���L submodule �]�w�C
)
pause
goto menu

:init
if exist .gitmodules (
    set /p redoInit=[INFO] �˴���w�� submodules �O���A�O�_���s��l�ơH(Y/N):
    if /I "!redoInit!" NEQ "Y" (
        echo [INFO] �w������l�� submodules�C
        goto menu
    )
)

if exist submodules_config.txt (
    echo [INFO] �}�l�� submodules_config.txt ��l�� submodules...
    for /f "tokens=1,2,3 delims= " %%A in (submodules_config.txt) do (
        call :submodule_init_line "%%A" "%%B" "%%C"
    )
    git submodule init
    git submodule update --remote --merge
    echo [INFO] Submodules ��l�Ƨ���
) else (
    echo [INFO] �������� submodules_config.txt�A���L submodule ��l��
)
goto menu

:submodule_init_line
set "subPath=%~1"
set "originURL=%~2"
set "upstreamURL=%~3"

git config -f .gitmodules --get-regexp "submodule.!subPath!.url" >nul 2>&1
if ERRORLEVEL 1 (
    echo [INFO] �[�J submodule�G!subPath!
    git submodule add !originURL! !subPath!
) else (
    echo [INFO] submodule !subPath! �w�s�b�A���L�[�J�C
)
exit /b

:pull_upstream
echo [INFO] �q upstream ��s�D�M��...
git remote | findstr "upstream" > nul
IF ERRORLEVEL 1 (
    set /p upstreamURL=�п�J�D�M�ת� upstream URL:
    git remote add upstream !upstreamURL!
)
git fetch upstream
git pull upstream main --allow-unrelated-histories

if exist submodules_config.txt (
    echo [INFO] �}�l��s submodules�]�q upstream �Ԩ��^...
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

:pull_from_origin
echo [INFO] �q GitHub�]origin�^�Ԧ^�D�M�׳̷s���e...
git pull origin main

if exist submodules_config.txt (
    echo [INFO] �q origin ��s submodules...
    for /f "tokens=1,2,3 delims= " %%a in (submodules_config.txt) do (
        set "subPath=%%a"
        if exist "!subPath!\\" (
            pushd "!subPath!" > nul
            git checkout main
            git pull origin main
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