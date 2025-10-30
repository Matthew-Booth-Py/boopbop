# Boopbop - 3D Roguelite Prototype

## What's Been Built

A basic 3D top-down roguelite prototype with the following features:

### Player (Blue Capsule)
- **Movement**: WASD or Arrow Keys
- **Auto-Attack**: Automatically swings axe every 1 second
- **Attack Range**: 2 unit radius around player
- **Health**: 100 HP
- **Speed**: 5 units/second

### Enemy (Red Cube)
- **AI Movement**: Slowly moves toward player
- **Projectile Shooting**: Shoots yellow balls every 2 seconds
- **Health**: 30 HP
- **Speed**: 2 units/second
- **Damage**: 10 HP per attack to player

### Projectile (Yellow Glowing Ball)
- **Movement**: Travels in straight line toward player
- **Damage**: 5 HP per hit
- **Lifetime**: Automatically destroys after 5 seconds
- **Visual**: Glowing yellow sphere with emission

### Scene Layout
- **Top-down camera** positioned to view the action
- **Green ground plane** (50x50 units)
- **Directional lighting** with shadows
- **2 test enemies** spawned at different positions

## How to Run

1. Open the project in Godot 4.5
2. Press F5 or click the Play button
3. The main scene will automatically load

## Controls

- **W/Up Arrow**: Move forward (north)
- **S/Down Arrow**: Move backward (south)
- **A/Left Arrow**: Move left (west)
- **D/Right Arrow**: Move right (east)

## Gameplay

1. Move around using WASD/Arrow keys
2. Your character automatically attacks enemies within range every 1 second
3. Enemies will chase you and shoot projectiles
4. Avoid the yellow projectile balls
5. Defeat enemies by staying in range and letting auto-attack work

## Technical Details

### Collision Layers
- **Layer 1**: Player
- **Layer 2**: Enemy
- **Layer 3**: Projectile

### File Structure
```
boopbop/
├── scenes/
│   ├── main.tscn         # Main game scene
│   ├── player.tscn       # Player character
│   ├── enemy.tscn        # Enemy character
│   └── projectile.tscn   # Enemy projectile
└── scripts/
    ├── player.gd         # Player logic and movement
    ├── enemy.gd          # Enemy AI and shooting
    └── projectile.gd     # Projectile movement and collision
```

### Key Features Implemented

✅ 3D top-down camera view
✅ WASD movement controls
✅ Player with auto-attacking (1 second cooldown)
✅ Enemy AI that follows player
✅ Enemy shooting projectiles
✅ Collision detection and damage system
✅ Health system for player and enemies
✅ Visual distinction (player=blue, enemy=red, projectile=yellow)
✅ Proper collision layers setup

## Next Steps for Expansion

To turn this into a full roguelite, consider adding:

1. **More Enemies**: Different enemy types with varied behaviors
2. **Upgrades/Power-ups**: Collect items that enhance abilities
3. **Wave System**: Spawn enemies in increasing difficulty waves
4. **Meta-Progression**: Unlock permanent upgrades between runs
5. **Visual Effects**: Particle effects for attacks and hits
6. **Sound Effects**: Audio feedback for actions
7. **UI**: Health bars, score counter, upgrade menu
8. **Procedural Generation**: Random arena layouts
9. **Multiple Weapons**: Different attack types and patterns
10. **Boss Fights**: Special challenging enemies

## Testing

The prototype is ready to test! Run the game and verify:

- ✅ Player moves smoothly with WASD
- ✅ Camera shows top-down view of action
- ✅ Player automatically attacks enemies in range
- ✅ Enemies move toward player
- ✅ Enemies shoot projectiles periodically
- ✅ Projectiles damage player on hit
- ✅ Player attacks damage enemies
- ✅ Entities die when health reaches 0

## Known Limitations

- Player attacks are invisible (no visual axe swing effect)
- No UI for health display
- No game over screen
- No restart functionality
- Enemies don't spawn dynamically
- No visual/audio feedback for damage

These are all areas for future enhancement!

