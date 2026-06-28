@echo off
echo ========================================
echo   廢棄宿舍 Steam 上傳腳本
echo ========================================
echo.

set STEAM_CMD=steamcmd
set APP_ID=你的App_ID
set BUILD_PATH=build
set DEPOT_ID=你的Depot_ID

echo 步驟 1: 確認 build 資料夾存在
if not exist %BUILD_PATH% (
    echo 錯誤：找不到 build 資料夾
    echo 請先在 Godot 中匯出遊戲
    pause
    exit /b 1
)

echo 步驟 2: 上傳到 Steam...
%STEAM_CMD% +login 你的帳號 +run_app_build %BUILD_PATH%\app_build.vdf +quit

echo.
echo 上傳完成！
pause
