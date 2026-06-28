# 🎮 Steam 上傳指南

## 快速測試（免費）

如果只是想測試，可以使用 **SpaceWar** 的 App ID：`480`

### 設定步驟

1. 在 `steam_appid.txt` 中輸入 `480`
2. 確保 Steam 客戶端已開啟
3. 執行遊戲

### 注意事項
- App ID 480 只能用於測試
- 正式上傳需要自己的 App ID

---

## 正式上傳流程

### 1. 取得 App ID

1. 前往 https://partner.steamgames.com/
2. 登入並繳納 $100 費用
3. 建立新應用 → 取得 App ID

### 2. 下載 SteamCMD

1. 前往 https://developer.valvesoftware.com/wiki/SteamCMD
2. 下載 Windows 版本
3. 解壓縮到 `C:\SteamCMD\`

### 3. 設定 Godot 匯出

1. 在 Godot 中：`Project → Export`
2. 新增 `Windows Desktop` 匯出預設
3. 設定匯出路徑：`build/abandoned_dormitory.exe`

### 4. 匯出遊戲

在 Godot 中執行：
```
Project → Export → Export Project
```

### 5. 建立 VDF 檔案

建立 `app_build.vdf`：
```
"app_build"
{
    "AppID" "你的App_ID"
    "Desc" "v1.0"
    "BuildOutput" "build\"
    "ContentRoot" "build\"
    "Depots"
    {
        "你的Depot_ID"
        {
            "FileMapping"
            {
                "LocalPath" "*"
                "DepotPath" "."
                "Recursive" "1"
            }
        }
    }
}
```

### 6. 上傳到 Steam

執行 SteamCMD：
```
cd C:\SteamCMD
steamcmd.exe +login 你的帳號 +run_app_build C:\path\to\app_build.vdf +quit
```

---

## 常見問題

### Q: 需要多少錢？
A: 一次性費用 $100 美金

### Q: 審核要多久？
A: 通常 1-2 天

### Q: 可以免費測試嗎？
A: 可以使用 App ID 480 (SpaceWar)

### Q: 需要什么格式？
A: Windows .exe + .pck 檔案

---

## 快速測試指令

```bash
# 1. 確保 Steam 客戶端開啟
# 2. 在 Godot 中設定 App ID = 480
# 3. 按 F5 執行遊戲
```

---

*更新日期：2026-06-28*
