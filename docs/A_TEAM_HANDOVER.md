# 🎨 A組交接清單：美術與場景

## 📋 交付物總覽

| # | 交付物 | 格式 | 交付路徑 |
|:---:|:---|:---:|:---|
| 1 | 宿舍主場景 | `.tscn` | `scenes/main/dormitory.tscn` |
| 2 | 宿舍模型包 | `.glb/.gltf` | `assets/models/environment/` |
| 3 | 道具模型包 | `.glb/.gltf` | `assets/models/props/` |
| 4 | 牆面貼圖 | `.png` | `assets/textures/walls/` |
| 5 | 地板貼圖 | `.png` | `assets/textures/floors/` |
| 6 | 材質球 | `.tres` | `assets/materials/` |
| 7 | 室內光源設定 | 場景內建 | `scenes/main/` |

---

## 🏗️ 場景交付細節

### 1. 宿舍主場景 (dormitory.tscn)

#### 場景樹結構
```
DormitoryMap (Node3D)
├── Environment/
│   ├── WorldEnvironment
│   ├── DirectionalLight3D (關閉)
│   └── VolumetricFog
├── Corridor/
│   ├── Floor
│   ├── Walls
│   └── Ceiling
├── Staircase/
│   ├── StairModel
│   └── Railing
├── Rooms/
│   ├── ManagementRoom/
│   │   ├── RoomStructure
│   │   ├── Furniture
│   │   └── Relic_SpawnPoint (Marker3D)
│   ├── PowerRoom/
│   │   ├── RoomStructure
│   │   ├── PowerBox
│   │   └── Relic_SpawnPoint (Marker3D)
│   ├── Bathroom/
│   │   ├── RoomStructure
│   │   └── Relic_SpawnPoint (Marker3D)
│   ├── Room101/
│   │   ├── RoomStructure
│   │   ├── Bed
│   │   ├── Desk
│   │   ├── Relic_SpawnPoint (Marker3D)
│   │   └── Door (Node3D)
│   ├── Room102/ ... Room205
│   └── ...
└── Props/
    ├── CRT_TV_01
    ├── Radio_01
    └── Flashlight_01
```

#### ⚠️ Marker3D 命名規範

| 節點名稱 | 用途 | B組使用方式 |
|:---|:---|:---|
| `Relic_SpawnPoint` | 遺物隨機生成點 | 遊戲開始時隨機放道具 |
| `Door` | 門互動點 | 掛載 door.gd 腳本 |
| `PowerBox` | 配電盤修復點 | 掛載 power_box.gd |
| `PlayerSpawn` | 玩家出生點 | 玩家載入位置 |
| `RadioSpawn` | 收音機位置 | CCTV 觀戰用 |

---

## 🎨 視覺規格

### 燈光設定
| 參數 | 數值 | 說明 |
|:---|:---:|:---|
| DirectionalLight3D | ❌ 關閉 | 模擬深夜 |
| OmniLight3D 顏色 | `#FFD89B` | 昏黃色 |
| OmniLight3D 強度 | 0.5-0.8 | 微弱照明 |
| OmniLight3D 衰減 | 1.5 | 自然衰減 |

### 環境效果
| 效果 | 參數 | 說明 |
|:---|:---|:---|
| SSAO | Radius: 0.5 | 環境光遮蔽 |
| SSAO | Intensity: 1.5 | 深度感 |
| Volumetric Fog | Density: 0.02 | 空氣塵埃 |
| Volumetric Fog | Albedo: 灰白 | 霧氣顏色 |

### 貼圖規格
| 類型 | 解析度 | 格式 |
|:---|:---:|:---:|
| 牆面 | 4K (4096x4096) | PNG |
| 地板 | 4K (4096x4096) | PNG |
| 道具 | 2K (2048x2048) | PNG |

---

## 📦 素材來源

| 素材類型 | 來源 | 網址 |
|:---|:---|:---|
| 建築結構 | Poly Haven | https://polyhaven.com/models |
| 80年代道具 | itch.io | 搜尋 "Retro Props" |
| 霉斑貼圖 | ambientCG | https://ambientcg.com |
| 磨石子地板 | ambientCG | https://ambientcg.com |

---

## ✅ 交接檢查清單

### 場景完成度
- [ ] 走廊結構拼裝完成
- [ ] 樓梯模型就位
- [ ] 管理室場景完成
- [ ] 配電室場景完成
- [ ] 浴室場景完成
- [ ] 101-205室場景完成（共5間）

### Marker3D 錨點
- [ ] 所有房間都有 `Relic_SpawnPoint`
- [ ] 所有門都有 `Door` 節點
- [ ] 配電室有 `PowerBox` 節點
- [ ] 出生點 `PlayerSpawn` 已放置

### 視覺效果
- [ ] DirectionalLight3D 已關閉
- [ ] 天花板光源已架設
- [ ] SSAO 已啟用
- [ ] Volumetric Fog 已啟用
- [ ] 霧氣密度已調整

### 檔案整理
- [ ] 所有模型放入 `assets/models/`
- [ ] 所有貼圖放入 `assets/textures/`
- [ ] 場景檔案放入 `scenes/main/`
- [ ] 已推送至 `art-branch`

---

## 🔄 合併流程

1. **A組完成場景後**
   ```bash
   git add .
   git commit -m "[art] 完成宿舍主場景"
   git push origin art-branch
   ```

2. **通知 B組合併**
   - B組將 `scenes/main/dormitory.tscn` 複製到自己的專案
   - 或使用 `git merge art-branch`

3. **合併後測試**
   - B組在場景中掛載腳本
   - 測試互動功能是否正常

---

## ⚠️ 注意事項

1. **Marker3D 命名必須統一**：B組腳本會直接引用這些名稱
2. **不要移動已掛載腳本的物件**：會導致腳本失效
3. **模型面數控制**：單一模型不超過 10k 面
4. **貼圖壓縮**：匯出時使用 Godot 壓縮格式

---

*建立日期：2026-06-27*
*負責人：A組美術總監*
