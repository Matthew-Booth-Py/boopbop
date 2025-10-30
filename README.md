# Boopbop - 3D Pixelart Roguelite

**A viral roguelite game in development using Godot 4.5**

---

## Table of Contents
- [About the Project](#about-the-project)
- [Development Journey](#development-journey)
- [Current Implementation](#current-implementation)
- [Technical Architecture](#technical-architecture)
- [Design Decisions](#design-decisions)
- [Research & Inspiration](#research--inspiration)
- [Roadmap](#roadmap)

---

## About the Project

Boopbop is a 3D pixelart roguelite game inspired by successful titles like Ball x Pit, Megabonk, and Vampire Survivors. The goal is to create a viral roguelite that combines:

- **Simple, addictive core gameplay** - Easy to pick up, hard to master
- **Auto-attack mechanics** - Focus on positioning and strategy over button mashing
- **Top-down 3D perspective** - Clear view of action with modern 3D graphics
- **Progressive difficulty** - Enemies that challenge without overwhelming
- **Replayability** - Randomization and variety that keeps players coming back

### Design Philosophy

Drawing from research into viral roguelites, Boopbop is built on these principles:
1. **Simple Core Mechanics, Deep Strategy** - WASD movement, auto-attacks
2. **Short Run Times** - Quick sessions perfect for "just one more run"
3. **Clear Visual Feedback** - Distinct colors and shapes for instant recognition
4. **Power Fantasy** - Feel increasingly powerful as you progress
5. **Accessibility** - Easy entry point with room for mastery

---

## Development Journey

### Phase 1: Research & Planning ✅

**Objective:** Understand what makes roguelites viral and successful

**Process:**
1. Analyzed three successful recent roguelites:
   - Ball x Pit (300k+ sales in 5 days)
   - Megabonk (117k concurrent players)
   - Vampire Survivors (viral indie success)

2. Identified common success elements:
   - Simple controls with deep strategy
   - Auto-attack or simplified combat systems
   - High replayability through randomization
   - Two-tier progression (within-run + meta)
   - Clear visual feedback
   - Content creator friendly

3. Created comprehensive research document analyzing:
   - Gameplay mechanics
   - Why each game became popular
   - Common patterns across successful titles
   - Design principles to follow

**Outcome:** Clear understanding of viral roguelite formula

### Phase 2: Prototype Development ✅

**Objective:** Create a minimal playable prototype to validate core mechanics

**Implementation:**
1. **Main Scene Setup**
   - 3D world with proper lighting
   - Top-down orthographic camera
   - Ground plane with collision
   - Environment configuration

2. **Player Character**
   - WASD movement controls
   - Auto-attack system (1 second cooldown)
   - Health system (100 HP)
   - Area-based attack detection
   - Blue capsule visual (easy to identify)

3. **Enemy AI**
   - Movement toward player
   - Projectile shooting (2 second cooldown)
   - Health system (30 HP)
   - Red cube visual (threatening appearance)

4. **Projectile System**
   - Straight-line movement
   - Collision detection with player
   - Damage on hit (5 HP)
   - Auto-destruction after timeout
   - Glowing yellow visual (clear danger indicator)

5. **Integration**
   - Proper collision layer setup
   - Scene instancing and management
   - Main scene as game entry point

**Technology Stack:**
- Engine: Godot 4.5
- Rendering: Forward Plus
- Language: GDScript
- Platform: Cross-platform (Mac, Windows, Linux)

**Outcome:** Fully functional prototype with core gameplay loop

---

## Current Implementation

### What's Playable Now

The current prototype includes:

#### Core Gameplay
- ✅ Player-controlled warrior character
- ✅ WASD/Arrow key movement
- ✅ Auto-attacking axe swing (1s cooldown)
- ✅ Enemy AI that chases player
- ✅ Enemy projectile shooting
- ✅ Damage system for both player and enemies
- ✅ Health tracking and death states

#### Visual & Technical
- ✅ Top-down 3D camera perspective
- ✅ Color-coded entities (Blue=Player, Red=Enemy, Yellow=Projectile)
- ✅ Basic materials and lighting
- ✅ Collision detection system
- ✅ Organized scene/script architecture

#### Game Feel
- ✅ Smooth movement controls
- ✅ Clear visual distinction between entities
- ✅ Automatic combat (inspired by Vampire Survivors)
- ✅ Enemy AI behavior
- ✅ Projectile physics

### How to Play

1. Open project in Godot 4.5
2. Press F5 or click Play
3. Use WASD or Arrow Keys to move
4. Stay near enemies to auto-attack them
5. Avoid yellow projectile balls
6. Survive as long as possible!

---

## Technical Architecture

### File Structure

```
boopbop/
├── README.md              # This file - project documentation
├── GAME_SETUP.md          # Technical setup and testing guide
├── project.godot          # Godot project configuration
├── icon.svg               # Project icon
│
├── scenes/
│   ├── main.tscn          # Main game scene (entry point)
│   ├── player.tscn        # Player character scene
│   ├── enemy.tscn         # Enemy character scene
│   └── projectile.tscn    # Enemy projectile scene
│
└── scripts/
    ├── player.gd          # Player movement and combat logic
    ├── enemy.gd           # Enemy AI and shooting behavior
    └── projectile.gd      # Projectile movement and collision
```

### Collision Layer Architecture

Proper separation of collision layers for clean interaction:

| Layer | Name | Purpose |
|-------|------|---------|
| 1 | Player | Player character collision |
| 2 | Enemy | Enemy character collision |
| 3 | Projectile | Enemy projectile collision |

**Interaction Matrix:**
- Player collides with: Enemy (Layer 2)
- Enemy collides with: Player (Layer 1)
- Projectile collides with: Player (Layer 1)

### Scene Hierarchy

```
Main (Node3D)
├── DirectionalLight3D (lighting with shadows)
├── Camera3D (orthographic top-down)
├── WorldEnvironment (ambient lighting)
├── Ground (StaticBody3D with collision)
├── Player (CharacterBody3D instance)
│   ├── MeshInstance3D (visual)
│   ├── CollisionShape3D (physics)
│   └── AttackArea (Area3D for attack detection)
└── Enemies (CharacterBody3D instances)
    ├── MeshInstance3D (visual)
    └── CollisionShape3D (physics)
```

---

## Design Decisions

### Why Auto-Attack?

**Inspiration:** Vampire Survivors' success with auto-attack mechanics

**Benefits:**
- Reduces cognitive load - players focus on positioning
- More accessible to casual players
- Creates strategic depth through positioning choices
- Mobile-friendly (potential future port)
- Easier to balance and tune

**Implementation:**
- 1 second cooldown (quick but not overwhelming)
- Area-based detection (rewards staying close to enemies)
- Automatic targeting (no manual aiming needed)

### Why Top-Down 3D?

**Inspiration:** Megabonk's successful 3D implementation, traditional roguelite perspective

**Benefits:**
- Clear view of battlefield and threats
- Familiar perspective from classic roguelites
- Allows for 3D visual effects and polish
- Easy to understand spatial relationships
- Good for both single-player and potential co-op

**Implementation:**
- Orthographic camera (no perspective distortion)
- 15 units above ground, slight angle
- 20 unit view size (good balance of detail and scope)

### Why WASD Controls?

**Inspiration:** Universal control scheme from all researched games

**Benefits:**
- Industry standard for PC games
- Intuitive for most players
- Easy to learn (5 second onboarding)
- Room to add additional controls later
- Gamepad mapping straightforward

**Implementation:**
- Uses Godot's built-in ui_* input actions
- Normalized diagonal movement (no speed advantage)
- Immediate response (no acceleration delay)

### Color Coding Strategy

Visual clarity is crucial for fast-paced roguelites:

- **Player (Blue):** Cool, friendly color
- **Enemies (Red):** Hot, threatening color  
- **Projectiles (Yellow + Emission):** High-visibility danger indicator
- **Ground (Green):** Neutral, doesn't compete for attention

**Principle:** Player should instantly know what's friendly, what's dangerous, and what's environmental

---

## Research & Inspiration

### Game Analysis Summary

This project began with deep research into three viral roguelites:

## Game Analysis

### 1. Ball x Pit

**Developer:** Kenny Sun  
**Publisher:** Devolver Digital  
**Release Date:** October 15, 2025  
**Platforms:** Nintendo Switch, PlayStation 5, Windows, macOS, Xbox Series X/S  

#### Gameplay Mechanics

**Two-Stage Gameplay Loop:**

1. **Action Stage (Arkanoid/Breakout-Inspired)**
   - Players control adventurers who launch balls at enemy monsters marching toward them
   - If monsters reach the bottom, they damage the adventurer
   - Run ends when adventurer takes too much damage
   - Combat is reminiscent of *Arkanoid* mixed with *Vampire Survivors*

2. **City-Building Stage**
   - Between runs, players return to surface to build a village
   - Use gold, blueprints, wood, and stone collected during runs
   - Buildings unlock new adventurer characters
   - Buildings provide permanent stat boosts and abilities
   - Workers can be launched to collect resources or advance construction

#### Core Systems

- **Leveling System:** Collecting gems from defeated monsters levels up the adventurer
- **Upgrade Choices:** Each level offers choice of:
  - New balls with unique properties
  - Upgrading existing balls
  - Passive items affecting gameplay
  
- **Ball Fusion/Evolution System:**
  - Special items can be "fissioned" to drop multiple powerups
  - Fuse two balls into one with combined effects
  - Evolve balls into more powerful versions

- **Meta-Progression:**
  - Gears from boss fights unlock deeper pit levels
  - New monsters and bosses at different levels
  - Multiple run segments ending with mini-bosses
  - Final stage features powerful boss character

#### Why It's Popular

**Sales Performance:**
- Sold 300,000+ copies in first 5 days across all platforms
- 95% approval rating on Steam

**Success Factors:**
1. **Innovative Genre Blend:** Combines ball-breakout nostalgia with modern roguelike mechanics and city-building strategy
2. **Engaging Progression:** Fusion and evolution mechanics encourage experimentation
3. **Two-Loop Design:** Provides variety - action for excitement, building for strategic planning
4. **Meta-Progression:** Village building gives long-term goals beyond individual runs
5. **Nostalgia Factor:** Taps into *Breakout*/*Arkanoid* nostalgia while modernizing it

**Critical Reception:**
- Metacritic: 84-88/100 depending on platform
- OpenCritic: 92% recommend
- Game Informer: 8.75/10
- Described as "a laboratory of potential" by Eurogamer

#### Basic Rules
- Launch balls at monsters to defeat them
- Don't let monsters reach the bottom
- Collect gems to level up mid-run
- Use resources to build village between runs
- Unlock new characters and abilities through building
- Progress deeper into the pit by defeating bosses

---

### 2. Megabonk

**Developer/Publisher:** vedinad  
**Release Date:** September 18, 2025  
**Platforms:** PC (Steam), Windows, Linux  

#### Gameplay Mechanics

**3D Survival Roguelike:**
- Players battle endless waves of enemies in randomly generated 3D arenas
- Full 3D movement with dashes and jumps
- Platforming elements add depth to combat
- No permanent upgrades between runs (pure skill-based)

#### Core Systems

- **Character System:**
  - Over 20+ unique characters with distinct abilities
  - Each character changes playstyle significantly
  
- **Upgrade System:**
  - 70+ items available
  - Random upgrades offered during runs
  - Diverse builds possible through combinations
  - Each run starts from scratch
  
- **Movement Focus:**
  - Dynamic 3D movement is core to gameplay
  - Dashing and jumping are survival tools
  - Platforming elements integrated into combat

#### Why It's Popular

**Player Numbers:**
- Peak of 117,336 concurrent players on Steam
- Charted higher than AAA titles like Call of Duty, Borderlands 4, and Marvel Rivals

**Success Factors:**
1. **Dynamic Movement:** 3D movement adds excitement and skill ceiling
2. **Character Diversity:** 20+ characters with unique playstyles
3. **Build Variety:** 70+ items create countless combinations
4. **Pure Skill:** No meta-progression means mastery matters
5. **High Replayability:** Randomized elements keep it fresh
6. **Fast-Paced Action:** Quick runs, immediate gratification

#### Basic Rules
- Survive against endless waves in 3D arenas
- Use movement, dashes, and jumps to avoid enemies
- Collect experience to level up
- Choose from random upgrade options
- No carries between runs - pure skill-based
- Each run is unique due to randomization

---

### 3. Vampire Survivors

**Developer/Publisher:** poncle  
**Release Date:** December 17, 2021  
**Platforms:** PC, macOS, Xbox One, Xbox Series X/S, iOS, Android  

#### Gameplay Mechanics

**Auto-Attack Survival:**
- Players control only movement; attacks are automatic
- Focus is entirely on positioning and evasion
- Survive against increasing waves of enemies
- Runs last until death (no traditional "win" initially)

#### Core Systems

- **Automatic Combat:**
  - Weapons attack automatically
  - Multiple weapons can be active simultaneously
  - Weapons have different patterns and ranges
  
- **Leveling System:**
  - Collect experience gems from defeated enemies
  - Level up grants choice of:
    - New weapons
    - Weapon upgrades
    - Passive items
  
- **Build Synergies:**
  - Certain weapon/item combinations create powerful synergies
  - Discovering combos is part of the appeal
  - Experimentation rewarded

- **Meta-Progression:**
  - Unlock new characters with unique starting weapons
  - Permanent upgrades can be purchased
  - New stages and challenges unlock over time

#### Why It's Popular

**Viral Success:**
- Started as indie darling, became massive hit
- Strong word-of-mouth and content creator appeal
- Mobile ports expanded reach significantly

**Success Factors:**
1. **Simple to Learn:** One-stick control (movement only)
2. **Addictive Loop:** "Just one more run" mentality
3. **Strategic Depth:** Despite simplicity, deep strategic choices
4. **Power Fantasy:** Players become overwhelmingly powerful
5. **Short Runs:** 15-30 minute runs perfect for quick sessions
6. **Discovery:** Finding weapon synergies is rewarding
7. **Accessibility:** Can be played casually or competitively
8. **Modding Community:** Strong community support and content

#### Basic Rules
- Move to avoid enemies
- Weapons attack automatically
- Collect experience gems to level up
- Choose upgrades each level
- Survive as long as possible
- Unlock new content with meta-progression
- Discover weapon combinations for synergies

---

## Common Success Elements

### 1. **Simple Core Mechanics, Deep Strategy**
- All three games have easy-to-understand basic controls
- Complexity emerges from systems interaction, not control complexity
- "Easy to learn, hard to master" design philosophy

### 2. **High Replayability**
- Procedural generation ensures unique runs
- Randomized upgrades/items create variety
- Multiple characters/classes change playstyle
- Discovery of new combinations keeps players engaged

### 3. **Satisfying Progression**

**Two Levels of Progression:**
- **Within-Run:** Immediate power growth feels rewarding
- **Meta-Progression:** Long-term goals maintain engagement

### 4. **Short Run Times**
- Runs typically 15-30 minutes
- Perfect for modern gaming sessions
- "Just one more run" is always tempting
- Quick iteration on builds and strategies

### 5. **Clear Visual Feedback**
- Players always understand what's happening
- Damage numbers, effects, and outcomes are clear
- Satisfying audio-visual feedback for actions

### 6. **Build Variety**
- Multiple viable strategies and builds
- Experimentation encouraged through random options
- Discovery of synergies creates "eureka" moments
- No single "best" build keeps meta fresh

### 7. **Power Fantasy**
- Players feel increasingly powerful during runs
- Overwhelming enemy hordes becomes satisfying
- Contrast between weak start and strong end is dramatic

### 8. **Accessibility**
- Simple controls (often just movement + minimal buttons)
- Can be played with various skill levels
- Mobile/console ports expand audience
- Low barrier to entry, high skill ceiling

### 9. **Content Creator Friendly**
- Interesting/exciting moments for streaming
- Each run tells a different story
- Viewer engagement through build discussions
- Competitive elements (time trials, challenges)

### 10. **Price Point**
- Generally budget-friendly ($5-20)
- High value proposition (hours of content)
- Lower risk for players to try
- Impulse purchase territory

---

## Key Takeaways for Viral RogueLite Development

### Must-Have Elements

1. **Addictive Core Loop**
   - One action that feels good to repeat
   - Immediate feedback and satisfaction
   - Clear cause-and-effect

2. **Meaningful Choices**
   - Upgrade decisions matter
   - Multiple viable paths
   - Trade-offs create interesting decisions

3. **Procedural Variety**
   - Random elements keep runs fresh
   - Enough variety to prevent repetition
   - Controlled randomness (not purely chaotic)

4. **Meta-Progression System**
   - Unlocks provide long-term goals
   - Permanent upgrades help struggling players
   - New content maintains interest

5. **Visual Clarity**
   - Always clear what's happening
   - Satisfying effects and feedback
   - Clean, readable interface

### Innovation Opportunities

Based on these games, successful viral roguelites often:
- **Blend Genres:** Combine unexpected gameplay elements (Ball x Pit's city building)
- **Modernize Classics:** Take old mechanics and add roguelike elements (Ball x Pit + Breakout)
- **Simplify Complexity:** Make traditionally complex genres accessible (Vampire Survivors + bullet hell)
- **Add Dimensionality:** Take 2D concepts to 3D or vice versa (Megabonk's 3D approach)

### Development Strategy

1. **Start with ONE fun mechanic** that feels satisfying
2. **Add randomization** to create variety
3. **Implement progression** within runs
4. **Add meta-progression** for long-term engagement
5. **Polish feedback loops** until they feel "juicy"
6. **Test replayability** - would you play 100 runs?
7. **Iterate on balance** - not too easy, not too hard
8. **Build community** - content creators are key

---

## Genre Formulas

### Ball x Pit Formula
`Classic Arcade Game + Roguelike Elements + City Building Meta-Progression = Viral Success`

### Megabonk Formula
`3D Arena Survival + Character Diversity + Pure Skill Focus = Competitive Engagement`

### Vampire Survivors Formula
`Auto-Shooter + Overwhelming Odds + Power Scaling = Addictive Loop`

---

## Design Principles

1. **Respect Player Time:** Quick runs, clear progress
2. **Reward Experimentation:** Make trying new things fun
3. **Create "Water Cooler Moments":** Memorable, shareable experiences
4. **Balance Skill and Luck:** Both should matter
5. **Iterate Quickly:** Players should want immediate retry after death
6. **Visual "Juice":** Satisfying effects and feedback
7. **Accessibility First:** Easy to start, complex to master
8. **Community Matters:** Foster discussion and sharing

---

## Recommended Reading

- [Ball x Pit Wikipedia](https://en.wikipedia.org/wiki/Ball_x_Pit)
- [GamesRadar: Ball x Pit Sales Analysis](https://www.gamesradar.com/games/roguelike/clever-roguelike-ball-x-pit-sold-300-000-copies-on-steam-and-consoles-in-5-days-forever-proving-mankind-yearns-for-1976-atari-icon-breakout/)
- [Megabonk Steam Page](https://store.steampowered.com/app/3405340/Megabonk/)
- Vampire Survivors community discussions and developer postmortems

---

## Roadmap

### ✅ Phase 1: Research (Completed)
- Market research and analysis
- Identification of success patterns
- Design principle documentation

### ✅ Phase 2: Prototype (Completed)
- Basic player movement
- Auto-attack system
- Enemy AI
- Projectile system
- Core gameplay loop

### 🔄 Phase 3: Core Enhancement (Current)

**Completed:**
- ✅ Health bar display
- ✅ Kill counter  
- ✅ Time survived counter
- ✅ Directional axe attacks
- ✅ Visual axe swing indicator

**In Progress:**
- 🔄 Enemy spawning system

**Backlog (Priority Order):**
1. **Experience & Level-Up System** (Vampire Survivors-style)
   - Enemy drops XP gems
   - Collect gems to level up
   - Choose from 3 random upgrades on level-up
   - Multiple weapon types
   - Stat upgrades (speed, damage, health)
   - Passive items

2. **Visual Feedback & Polish**
   - Particle effects on enemy death
   - Particle effects on player hits
   - Screen shake when damaged
   - Floating damage numbers
   - Hit flash effects
   - Sound effects (hits, deaths, attacks)
   - Background music

3. **Game Over & Restart System**
   - Death screen when health reaches 0
   - Display final stats (kills, time survived)
   - High score tracking
   - Restart button
   - Return to menu option

### 📋 Phase 4: Progression Systems

**Within-Run Progression:**
- Experience gain from kills
- Level-up system
- Upgrade choices (Vampire Survivors-style)
- Multiple weapon types
- Passive item pickups

**Meta-Progression:**
- Persistent unlocks between runs
- New character types
- Permanent stat upgrades
- Achievement system

### 📋 Phase 5: Content Expansion

**Variety:**
- 5-10 enemy types with unique behaviors
- Boss enemies
- Wave/arena system
- Environmental hazards
- Power-ups and pickups

**Replayability:**
- Procedural arena generation
- Random enemy spawns
- Multiple character classes
- Daily challenges

### 📋 Phase 6: Polish & Release

**Polish:**
- Pixel art shaders for 3D models
- VFX polish pass
- Audio design
- UI/UX refinement
- Balance tuning

**Release Prep:**
- Steam page setup
- Trailer creation
- Press kit
- Community building
- Content creator outreach

### 📋 Phase 7: Post-Launch

**Support:**
- Bug fixes
- Balance patches
- Community feedback integration

**Expansion:**
- New characters
- New enemies
- New mechanics
- Potential meta-progression layer (inspired by Ball x Pit)

---

## Development Principles

Based on our research, we're following these principles:

### 1. Playtest Early, Playtest Often
- Prototype must be fun within first 30 seconds
- If it's not fun at core, polish won't fix it
- Get feedback from players outside your circle

### 2. Iterate Quickly
- Small, rapid changes over large features
- Test one variable at a time
- Be willing to cut features that don't work

### 3. Focus on Feel
- Game feel > feature list
- Juicy feedback for every action
- Polish the core before expanding

### 4. Build for Virality
- Content creator friendly features
- Shareable moments
- Clear, readable gameplay for streams
- Potential for "broken" builds (discovery factor)

### 5. Respect Player Time
- Quick runs (target 5-15 minutes)
- Fast restart after death
- Clear progress indicators
- No artificial padding

---

## Contributing

Currently a solo project by Matthew Booth. Open to collaboration as development progresses!

### Feedback Welcome
If you playtest the prototype:
- What felt good?
- What felt frustrating?
- Did you want to play again?
- What would make it more fun?

---

## Credits

**Development:** Matthew Booth  
**Engine:** Godot 4.5  
**Inspiration:** Ball x Pit, Megabonk, Vampire Survivors  

---

## License

[To be determined]

---

## Contact

[Contact information to be added]

---

*Last Updated: October 30, 2025*  
*Project Status: Prototype Phase Complete*
