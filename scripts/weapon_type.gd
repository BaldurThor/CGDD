class_name WeaponType extends Resource

enum TargetPriority { CLOSEST, FARTHEST, RANDOM, STRONGEST }

@export_category("Primary Stats")
## Base damage dealt by each projectile fired by the weapon
@export_range(1.0, 1.0, 1.0, "or_greater") var damage: float
## Base interval of which the weapon attacks
@export_range(0.1, 1.0, 0.1, "or_greater") var attack_speed: float
## Chance of an attack from the weapon dealing bonus damage
@export_range(0.0, 100.0, 0.1, "or_greater") var crit_chance: float
## Multiplier to attacks that are critical strikes
@export_range(1.0, 3.0, 0.1, "or_greater") var crit_damage: float

@export_category("Secondary Stats")
## Whether to fire all the projectiles at once or with a short delay between them
@export var burst: bool = false
## The delay between each projectile spawning when burst is enabled
@export var delay_between_burst_projectiles: float
## The number of enemies that a projectile fired by the weapon can hit before despawning
@export_range(0, 100, 1) var pierce_count: int
## The multiplier to the linear velocity of the projectile fired by the weapon
@export var projectile_speed: float
## Number of projectiles fired by the weapon
@export_range(1, 25, 1, "or_greater") var projectile_count: int
## The min/max angle of which the projectile is curved when the weapon attacks
@export var projectile_spread: Curve

@export_category("Configuration")
## The type of enemy the weapon targets
@export var target_priority: TargetPriority

@export_category("Resources")
## The sprite used by the weapon
@export var sprite: Texture2D
## The scene for the bullet fired by the weapon
@export var bullet_type: PackedScene
## The sound-effect played on attack
@export var attack_sfx: AudioStream
