# Roblox Jousting Game

A medieval-themed multiplayer jousting game built for Roblox, featuring horseback combat with lances in an arena setting.

## 🎮 Game Features

- **Multiplayer Arena Combat**: Up to 8 players can compete simultaneously
- **Horse-mounted Combat**: Players ride horses and wield lances
- **Charging Mechanics**: Build up charge for more powerful attacks
- **Dynamic Scoring System**: Points awarded for hits and eliminations
- **Medieval Arena**: Fully enclosed jousting arena with spawn points
- **Real-time Leaderboard**: Track scores and rankings during gameplay
- **Visual Effects**: Combat effects, charge indicators, and hit feedback

## 🕹️ Controls

| Input | Action |
|-------|--------|
| `W/A/S/D` | Move horse around the arena |
| `Left Shift` (hold) | Charge attack for increased damage and range |
| `Space` or `Left Click` | Attack with lance |
| `Mouse` | Aim and look around |

## 📁 File Structure

```
roblox-jousting-game/
├── scripts/
│   ├── Main.lua           # Main game entry point
│   ├── GameManager.lua    # Server-side game logic
│   └── PlayerController.lua # Client-side player controls
├── gui/
│   └── GameUI.lua         # User interface elements
├── models/               # 3D models (placeholder)
├── sounds/               # Sound effects (placeholder)
└── README.md            # This file
```

## 🎯 Gameplay

### Objective
- Compete against other players in medieval jousting combat
- Score points by hitting opponents with your lance
- Survive and eliminate other players to win rounds

### Scoring System
- **Lance Hit**: 10 points (20 points when charging)
- **Player Elimination**: 50 bonus points
- **Charge Bonus**: 1.5x damage multiplier when charging

### Combat Mechanics
- **Basic Attack**: 20 damage, 10 points
- **Charge Attack**: 35 damage, 20 points, increased range
- **Health**: 100 HP per player
- **Respawn**: 5-second respawn timer after elimination

## 🏗️ Installation & Setup

### For Roblox Studio:

1. **Create New Place**: Open Roblox Studio and create a new place
2. **Add Scripts**: 
   - Place `Main.lua` in ServerScriptService
   - Place `GameManager.lua` and `PlayerController.lua` in ServerStorage
   - Place `GameUI.lua` in StarterGui
3. **Configure Modules**: Ensure proper require() paths between scripts
4. **Test**: Use "Play Solo" or "Start Server" to test the game

### Script Placement:
```
ServerScriptService/
├── Main (ServerScript)

ServerStorage/
├── GameManager (ModuleScript)
├── PlayerController (ModuleScript)

StarterGui/
├── GameUI (LocalScript)
```

## 🛠️ Technical Details

### Architecture
- **Server-Side**: Game state management, player tracking, arena setup
- **Client-Side**: Input handling, movement controls, UI updates
- **Modular Design**: Separated concerns for easy maintenance and expansion

### Key Components

#### GameManager.lua
- Arena creation and boundary setup
- Player spawn point management
- Combat hit detection and damage dealing
- Score tracking and leaderboard updates
- Round management and game state

#### PlayerController.lua
- WASD movement controls for horses
- Charge mechanic with visual effects
- Lance attack system with raycast hit detection
- Input handling and movement physics

#### GameUI.lua
- Health bar and charge meter
- Real-time scoreboard
- Crosshair and HUD elements
- Victory screens and notifications
- Control instructions display

## 🎨 Customization

### Modifying Arena Size
```lua
-- In GameManager.lua
local GAME_CONFIG = {
    ARENA_SIZE = 200, -- Change this value
    -- ... other settings
}
```

### Adjusting Combat Settings
```lua
-- In PlayerController.lua
local MOVEMENT_CONFIG = {
    HORSE_SPEED = 30,        -- Horse movement speed
    TURN_SPEED = 5,          -- Turning rate
    LANCE_REACH = 10,        -- Attack range
    CHARGE_MULTIPLIER = 1.5  -- Charge damage boost
}
```

### Adding Sound Effects
Place sound files in the `sounds/` directory and reference them in the scripts:
```lua
local hitSound = Instance.new("Sound")
hitSound.SoundId = "rbxasset://sounds/your_sound.mp3"
hitSound.Parent = workspace
hitSound:Play()
```

## 🐛 Known Limitations

- This is a basic implementation intended for demonstration
- 3D horse models are simplified (uses basic parts with meshes)
- Sound effects need to be added separately
- Advanced networking features may need additional implementation for larger servers

## 🚀 Future Enhancements

- **3D Horse Models**: Replace basic parts with detailed horse models
- **Weapon Variety**: Add different types of lances and weapons
- **Power-ups**: Special abilities and temporary boosts
- **Tournament Mode**: Bracket-style elimination tournaments
- **Customization**: Player and horse appearance options
- **Advanced Physics**: More realistic horse movement and combat

## 📝 License

This project is part of a coding exercise and is provided as-is for educational purposes.

## 🤝 Contributing

This is a demonstration project. For improvements or suggestions, consider:
- Adding more detailed 3D models
- Implementing advanced networking features
- Creating additional game modes
- Adding sound effects and music
- Improving visual effects and animations

---

**Note**: This game requires Roblox Studio to run and is designed for the Roblox platform using Lua scripting.