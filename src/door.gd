extends StaticBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer 
@onready var colisor: CollisionShape2D = $CollisionShape2D

var is_open: bool = false

func open_door() -> void:
	if animation_player.is_playing():
		return

	print("Porta recebendo comando de abrir")
	animation_player.play("open")
	is_open = true


func close_door() -> void:
	if not is_open: 
		return 
	is_open = false

	animation_player.play("close")