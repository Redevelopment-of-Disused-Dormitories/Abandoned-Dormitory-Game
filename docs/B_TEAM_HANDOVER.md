# 💻 B組交接清單：系統與連線工程

## 📋 交付物總覽

| # | 交付物 | 格式 | 交付路徑 |
|:---:|:---|:---:|:---|
| 1 | Steam 管理器 | `.gd` | `scripts/autoloads/steam_manager.gd` |
| 2 | 語音管理器 | `.gd` | `scripts/autoloads/voice_manager.gd` |
| 3 | 遊戲管理器 | `.gd` | `scripts/autoloads/game_manager.gd` |
| 4 | 主選單腳本 | `.gd` | `scripts/ui/main_menu.gd` |
| 5 | 大廳腳本 | `.gd` | `scripts/ui/lobby_ui.gd` |
| 6 | 玩家控制 | `.gd` | `scripts/player/player.gd` |
| 7 | 門互動腳本 | `.gd` | `scripts/interaction/door.gd` |
| 8 | 黑霧 AI | `.gd` | `scripts/ai/fog_ai.gd` |
| 9 | UI 場景 | `.tscn` | `scenes/ui/` |
| 10 | 玩家場景 | `.tscn` | `scenes/player/player.tscn` |

---

## 🔧 Autoload 腳本

### 1. steam_manager.gd
**功能**：Steam API 初始化、大廳建立/加入、聊天

```gdscript
# 核心功能
- init_steam()              # 初始化 Steam
- create_lobby()            # 建立大廳
- join_lobby()              # 加入大廳
- leave_lobby()             # 離開大廳
- update_lobby_members()    # 更新成員列表
- send_lobby_chat()         # 發送聊天

# 信號
- steam_initialized         # Steam 初始化完成
- lobby_created             # 大廳建立成功
- lobby_joined              # 成功加入大廳
- lobby_chat_message        # 收到聊天訊息
```

### 2. voice_manager.gd
**功能**：語音錄製、播放、3D 空間衰減

```gdscript
# 核心功能
- start_recording()         # 開始錄音
- stop_recording()          # 停止錄音
- get_mic_level()           # 取得麥克風音量
- has_microphone()          # 檢查麥克風

# 3D 空間效果
- 距離衰減：2m 內 0dB，20m 外 -40dB
- 隔牆濾鏡：低通濾鏡 (Low-pass Filter)
```

### 3. game_manager.gd
**功能**：遊戲狀態、遺物計數、勝負判定

```gdscript
# 核心功能
- start_game()              # 開始遊戲
- player_died()             # 玩家死亡
- relic_collected()         # 收集遺物
- check_victory()           # 檢查勝利條件

# 全域變數
- exorcism_count: int       # 已收集遺物數
- total_relics: int = 7     # 所需遺物總數
- players_alive: Array      # 存活玩家
```

---

## 🖥️ UI 腳本

### 4. main_menu.gd
**功能**：主選單 4 個按鈕

| 按鈕 | 功能 |
|:---|:---|
| 創立宿舍伺服器 | 彈出輸入視窗，建立 Steam 大廳 |
| 尋找探險隊伍 | 顯示伺服器列表，可加入 |
| 調節配備 | 設定畫質、音量、麥克風 |
| 離開調查 | 關閉遊戲 |

### 5. lobby_ui.gd
**功能**：大廳等待介面

| 元件 | 功能 |
|:---|:---|
| 隊員點名簿 | 顯示 7 個玩家槽位 |
| 麥克風圖標 | 講話時閃爍 |
| 準備狀態 | 未準備/已準備 |
| 簽到按鈕 | 房客按 Ready |
| 開始按鈕 | 房主按 Start |

#### ⚠️ 核心限制
```
if any_player_mic_off:
    ready_button.disabled = true
    show_message("玩家 XXX 的通訊設備未就緒")
```

---

## 🎮 遊戲腳本

### 6. player.gd
**功能**：玩家控制、互動、死亡

```gdscript
# 核心功能
- 移動控制 (WASD)
- 視角轉滑鼠
- E鍵互動
- 手電筒開關
- 死亡處理
```

### 7. door.gd
**功能**：門的互動與隔音

```gdscript
# 核心功能
- toggle_door()             # 開關門 (Tween 動畫)
- update_audio_filter()     # 門關時加低通濾鏡

# 互動方式
- 玩家靠近門
- 按 E 鍵
- 門旋轉 90 度
```

### 8. fog_ai.gd
**功能**：黑霧 AI 行為

```gdscript
# 核心功能
- navigate_to_target()      # NavMesh 導航
- on_noise_event()          # 聽覺偵測
- stun()                    # 被手電筒僵直 2 秒

# 行為模式
- 巡邏：隨機移動
- 追蹤：聽到聲音後追擊
- 僵直：被手電筒照到暫停
```

---

## 📁 場景檔案

### 9. UI 場景 (scenes/ui/)
| 場景 | 用途 |
|:---|:---|
| main_menu.tscn | 主選單 |
| server_browser.tscn | 伺服器瀏覽器 |
| settings.tscn | 設定選單 |
| lobby.tscn | 大廳等待 |
| player_slot.tscn | 玩家槽位元件 |
| voice_status.tscn | 語音狀態顯示 |

### 10. 玩家場景 (scenes/player/)
| 場景 | 用途 |
|:---|:---|
| player.tscn | 玩家角色 |

#### 玩家場景結構
```
Player (CharacterBody3D)
├── CollisionShape3D
├── Camera3D
├── Hand (Node3D)
│   └── Flashlight (SpotLight3D)
├── InteractionRay (RayCast3D)
├── VoicePlayer (AudioStreamPlayer3D)
└── UI (CanvasLayer)
    └── VoiceStatus
```

---

## 🔗 與 A組對接

### 需要 A組提供的物件
| A組物件 | B組腳本 | 對接方式 |
|:---|:---|:---|
| `Relic_SpawnPoint` | game_manager.gd | `get_node("Relic_SpawnPoint")` |
| `Door` | door.gd | 掛載腳本到此節點 |
| `PowerBox` | power_box.gd | 掛載腳本到此節點 |
| `PlayerSpawn` | player.gd | 玩家載入位置 |
| `RadioSpawn` | cctv_system.gd | 觀戰視角 |

### 場景引用
```gdscript
# 從 A組場景引用節點
var spawn_points = get_tree().get_nodes_in_group("relic_spawn_points")
var doors = get_tree().get_nodes_in_group("doors")
var radios = get_tree().get_nodes_in_group("radios")
```

---

## ✅ 交接檢查清單

### Autoload 腳本
- [ ] `steam_manager.gd` 完成並測試
- [ ] `voice_manager.gd` 完成並測試
- [ ] `game_manager.gd` 完成並測試
- [ ] 已加入 Godot Autoload 設定

### UI 腳本
- [ ] `main_menu.gd` 完成
- [ ] `lobby_ui.gd` 完成
- [ ] `server_browser.gd` 完成
- [ ] `voice_status.gd` 完成

### 遊戲腳本
- [ ] `player.gd` 完成
- [ ] `door.gd` 完成
- [ ] `fog_ai.gd` 完成
- [ ] `power_box.gd` 完成

### 場景檔案
- [ ] 所有 UI 場景建立
- [ ] 玩家場景建立
- [ ] 已推送至 `logic-branch`

---

## 🔄 合併流程

1. **B組完成腳本後**
   ```bash
   git add .
   git commit -m "[feat] 完成大廳系統"
   git push origin logic-branch
   ```

2. **合併 A組場景**
   ```bash
   git merge art-branch
   ```

3. **掛載腳本到場景**
   - 將 `door.gd` 掛載到 A組的 `Door` 節點
   - 將 `fog_ai.gd` 掛載到黑霧粒子物件
   - 測試互動功能

---

## ⚠️ 注意事項

1. **Marker3D 命名**：必須與 A組一致
2. **Autoload 順序**：steam_manager → voice_manager → game_manager
3. **Steam App ID**：測試時使用 480
4. **回呼機制**：每幀執行 `Steam.run_callbacks()`

---

## 📚 參考資源

| 資源 | 網址 |
|:---|:---|
| GodotSteam 文檔 | https://godotsteam.com |
| GodotSteam 大廳教程 | https://godotsteam.com/tutorials/lobbies/ |
| GodotSteam 語音教程 | https://godotsteam.com/tutorials/voice/ |
| Steam Multiplayer Peer | https://godotengine.org/asset-library/asset/2258 |

---

*建立日期：2026-06-27*
*負責人：B組系統工程師*
