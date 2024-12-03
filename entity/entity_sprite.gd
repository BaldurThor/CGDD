class_name EntitySprite extends Sprite2D

func set_flash(value: bool):
	if material is ShaderMaterial:
		material.set_shader_parameter("flash", value)

func flash():
	if material is ShaderMaterial:
		material.set_shader_parameter("flash", true)
		await get_tree().create_timer(0.5).timeout
		material.set_shader_parameter("flash", false)
