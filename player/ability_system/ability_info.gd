class_name AbilityInfo extends Resource

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
}

@export var ability_script: Script
@export var name: String
@export var rarity: Rarity = Rarity.COMMON
@export var icon: Texture2D

@export var incompatabilities: Array[AbilityInfo]
