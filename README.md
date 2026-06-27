# 🏚️ 廢棄宿舍 (Abandoned Dormitory Game)

一款 **7人合作恐怖遊戲**，玩家需在廢棄宿舍中收集7件遺物，躲避黑霧AI的追擊，透過語音溝通協作逃出。

---

## 🎮 遊戲特色

| 特色 | 說明 |
|:---|:---|
| 🎤 **強制語音** | 必須開麥才能開始遊戲，增強沉浸感 |
| 🗣️ **3D 空間語音** | 聲音會隨距離衰減，隔牆需用低通濾鏡 |
| 👻 **黑霧 AI** | 聽覺導向，大叫會被追蹤，手電筒可暫時僵直 |
| 📹 **CCTV 觀戰** | 死亡後透過黑白收音機干擾隊友 |
| 🎯 **7 件遺物** | 收集完畢才能解鎖大門逃出 |

---

## 🛠️ 技術棧

| 技術 | 用途 |
|:---|:---|
| **Godot 4.x** | 遊戲引擎 |
| **GodotSteam** | Steam 整合 (大廳、語音、好友邀請) |
| **Steam Multiplayer Peer** | P2P 連線 |
| **GDScript** | 遊戲腳本 |
| **NavMesh** | AI 導航網格 |

---

## 📁 專案結構

```
Abandoned-Dormitory-Game/
├── addons/                    # 外掛
│   ├── godotsteam/            # Steam SDK
│   └── steam_multiplayer_peer/
├── autoloads/                 # 全域管理器
│   ├── steam_manager.gd
│   ├── voice_manager.gd
│   └── game_manager.gd
├── scenes/                    # 場景
│   ├── ui/                    # UI 場景
│   ├── player/                # 玩家場景
│   └── main/                  # 主遊戲場景
├── scripts/                   # 腳本
│   ├── autoloads/
│   ├── ui/
│   ├── player/
│   └── ai/
├── assets/                    # 素材
│   ├── models/
│   ├── textures/
│   └── audio/
└── project.godot
```

---

## 👥 團隊分工

| 角色 | 負責範圍 | Git 分支 |
|:---|:---|:---|
| 🎨 **A組 美術** | 場景建模、視覺拋光、素材下載 | `art-branch` |
| 💻 **B組 程式** | 連線架構、語音系統、AI 邏輯、UI | `logic-branch` |
| 🎮 **C組 專案** | 進度追蹤、QA 測試、合併管理 | `main` |

---

## 🚀 快速開始

### 環境需求
- Godot 4.4+
- Steam 桌面客戶端
- Steamworks 開發者帳號

### 安裝步驟
1. Clone 專案
   ```bash
   git clone https://github.com/Redevelopment-of-Disused-Dormitories/Abandoned-Dormitory-Game.git
   ```

2. 下載 GodotSteam
   - 前往 https://godotengine.org/asset-library/asset/2445
   - 解壓到 `addons/godotsteam/`

3. 設定 App ID
   - 在 Godot 中：`Project → Project Settings → Steam → Initialization`
   - 輸入你的 Steam App ID（測試用：480）

4. 啟動遊戲
   - 開啟 Godot 並載入專案
   - 按 F5 執行

---

## 📋 開發進度

| 階段 | 任務 | 狀態 |
|:---:|:---|:---:|
| 1 | 建立 Godot 專案 | ✅ |
| 2 | 安裝 GodotSteam | ⬜ |
| 3 | 實作大廳系統 | ⬜ |
| 4 | 實作語音系統 | ⬜ |
| 5 | 建立宿舍場景 | ⬜ |
| 6 | 實作 AI 行為 | ⬜ |
| 7 | 整合測試 | ⬜ |
| 8 | Steam 上架 | ⬜ |

---

## 📜 開發規範

### Git 分支
- `main`：穩定版本，僅透過 PR 合併
- `art-branch`：A組美術開發
- `logic-branch`：B組程式開發

### 提交訊息格式
```
[type] 簡短描述

type:
  feat     - 新功能
  fix      - 修復 Bug
  art      - 美術資源
  docs     - 文檔更新
  refactor - 重構
  test     - 測試
```

### 合併流程
1. 每週五進行合併
2. A組將場景匯入 B組專案
3. C組負責測試與驗收

---

## 📄 授權條款

本專案採用 [MIT License](LICENSE) 授權。

---

## 📞 聯絡方式

- **GitHub Issues**：回報 Bug 或建議
- **Discord**：即時討論（待建立）

---

*最後更新：2026-06-27*
