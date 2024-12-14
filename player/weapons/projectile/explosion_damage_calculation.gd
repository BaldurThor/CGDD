class_name ExplosionDamageCalculation extends Node

# Projectile or Explosion
@onready var explosion: Area2D = $".."

## Calculate the damage for the explosion. Explosives cannot crit, but their secondary effects may.
func calculate_damage() -> int:
	var damage = explosion.weapon_group.get_base_damage()
	return max(1, int(damage)) * explosion.weapon_group.player_stats.non_crit_damage_multiplier

func calculate_knockback() -> int:
	return explosion.weapon_group.get_knockback()
