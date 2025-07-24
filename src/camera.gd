extends Camera2D


@export var target:CharacterBody2D ##Alvo da camera

@export_group("Juice Settings")

@export_range(0.0, 1.0) var smoothing: float = 0.05 ##Quão suavemente a camera vai "esperar" o movimento do player

@export var velocity_influence: float = 0.1

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		push_error("Nenhum alvo foi definido!")
		return #Não tem um alvo definito

	var target_position = target.global_position

	if "velocity" in target:
		var velocity_offset = target.velocity * velocity_influence

		target.velocity = velocity_offset


	global_position = global_position.lerp(target_position, smoothing)