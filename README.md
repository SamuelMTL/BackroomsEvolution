# Backrooms Evolution

A mobile idle/merge game built in Godot 4 where creatures roam a backrooms-inspired room, merging together to evolve into higher forms.

## Gameplay

- Creatures spawn automatically over time and wander around the room
- Drag a creature on top of another of the same type to merge them into the next evolution
- Each creature generates passive income per second
- Use your income to buy more creatures or upgrade their income in the Shop

## Creature Evolution Chain

| Level | Name | Income/s |
|-------|------|----------|
| 1 | Researcher | 0.5 |
| 2 | Bacteria Entity | 2.0 |
| 3 | Bonestealer | 8.0 |
| 4 | Nova | 32.0 |
| 5 | Apex | 128.0 |

Higher level creatures are unlocked by merging — they won't appear in the Shop until you've obtained them at least once.

## Shop

- **Buy Creatures** — purchase any creature you've already unlocked. Price scales up by ×1.15 with each purchase.
- **Upgrades** — boost a creature type's income with up to 3 upgrade levels (×2, ×4, ×8). Upgrades apply instantly to all active creatures of that type.

## Project Structure

```
backrooms-evolution/
├── Assets/             # Sprites and background
├── Autoloads/          # Global singletons
│   ├── EntityRegistry.gd   # Ordered list of creature types and upgrade registration
│   ├── MoneyManager.gd     # Passive income accumulation and multipliers
│   └── ShopManager.gd      # Shop state: unlocks, purchases, upgrades
├── Entitys/            # LittleMan scene and script (base creature)
├── Resources/
│   ├── EntityData.gd       # Resource class defining a creature type
│   ├── UpgradeData.gd      # Resource class defining an upgrade
│   ├── Type01–05.tres      # Creature definitions
│   └── Upgrades/           # 15 upgrade definitions (5 types × 3 levels)
├── Scenes/             # Main game scene
└── UI/                 # MoneyUI, ShopUI, ShopButton
```

## Adding a New Creature Type

1. Create `Resources/TypeXX.tres` based on an existing one — set `type_name`, `color`, `speed`, `base_income`, and optionally `sprite_frames`
2. Create `Resources/Upgrades/TypeXXUpgrade1/2/3.tres` for its upgrades
3. Add the new type to the `types` array in `Autoloads/EntityRegistry.gd` and its price to `BUY_PRICES`
4. Add the new upgrades to the `upgrades` array in `EntityRegistry.gd`

## Adding Sprites to a Creature

1. Add `@export var sprite_frames: SpriteFrames` is already present on `EntityData`
2. Create a `SpriteFrames` `.tres` file referencing your frame PNGs
3. Assign it to the creature's `.tres` file — the game will automatically use the animated sprite instead of the colored square placeholder

## Tech

- **Engine:** Godot 4.x (Mobile renderer)
- **Target platform:** Android / iOS (portrait 1080×1920)
- **Language:** GDScript
