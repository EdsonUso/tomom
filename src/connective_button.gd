extends Area2D

class_name ConnectableButton

signal pressed
signal released


var is_activated: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var linked_button: Node = null

func set_linked_button(button_node: Node) -> void:
	linked_button = button_node

func activate():
	if is_activated: return

	is_activated = true
	animation_player.play("press_down")
	pressed.emit()

	if is_instance_valid(linked_button):
		linked_button.force_activate()

func force_active() ->void:
	if is_activated : return
	is_activated = true

	animation_player.play("press_down")
	#Não emitir sinal para não evitar loops