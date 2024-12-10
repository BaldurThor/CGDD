class_name AbilityInfo extends Resource

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	CORRUPTED,
}

enum AbilityType {
	PASSIVE,
	CORRUPTED,
	WEAPON,
}

@export var ability_script: Script
@export var name: String
## Describes the positive effects of the ability
@export var positive_effects: Array[String]
## Describes the negative effects of the ability
@export var negative_effects: Array[String]
## Describes the ability pool used by the ability
@export var type: AbilityType
## Tags that indicate what text to show when the ability is hovered.
@export var tags: Array[String]
## Describes some lore or misc text
@export var flavor_text: String
## The max number of copies the player can have of this ability. 0 = no limit.
@export var max_amount: int
@export var rarity: Rarity = Rarity.COMMON
@export var icon: Texture2D
# If above 0, then this ability will always be present at the selected level
@export var guaranteed_at: int = 0
# If above 0, then this ability will not show up until a certain level. Can
# be paired up with guarenteed_at to have it only show up at that level
@export var required_level: int = 0

@export var incompatabilities: Array[AbilityInfo]
@export var requirements: Array[AbilityInfo]
