class_name AbilityInfo extends Resource

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
}

@export var ability_script: Script
@export var name: String
## Describes the positive effects of the ability
@export var positive_effects: Array[String]
## Describes the negative effects of the ability
@export var negative_effects: Array[String]
## Describes some lore or misc text
@export var flavor_text: String
## The max number of copies the player can have of this ability. 0 = no limit.
@export var max_amount: int
@export var rarity: Rarity = Rarity.COMMON
@export var icon: Texture2D

@export var incompatabilities: Array[AbilityInfo]
