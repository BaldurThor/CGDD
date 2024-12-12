class_name AbilityPool extends Resource

## Passive abilities
@export var abilities: Array[AbilityInfo] = []
## Abilities that grant the player a weapon
@export var weapons: Array[AbilityInfo] = []
## Abilities that are only offered on killing a boss
@export var corrupted_abilities: Array[AbilityInfo] = []
## The weight of a common ability being chosen.
@export var rate_common: int = 0
## The weight of an uncommon ability being chosen.
@export var rate_uncommon: int = 0
## The weight of a rare ability being chosen.
@export var rate_rare: int = 0
## The levels at which the player is guaranteed to get a choice of weapons
@export var weapon_guarantee_breakpoint: int = 5
## The xp percentage of the player's level that they get for skipping a weapon
@export var weapon_skip_xp_multiplier: float = 0.50
## The xp percentage of the player's level that they get for skipping a normal ability
@export var passive_skip_xp_multiplier: float = 0.50
## The xp percentage of the player's level that they get for skipping a corrupted passive
@export var corrupted_skip_xp_multiplier: float = 1.00
