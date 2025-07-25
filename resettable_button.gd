extends Area2D

signal pressed
signal relased

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bodies_on_top:int = 0

func _on_body_entered(body) -> void:

	if bodies_on_top == 0:
		animation_player.play("press_down")
		pressed.emit()

	bodies_on_top += 1


func _on_body_exited(body) -> void:
	bodies_on_top -= 1

	if bodies_on_top == 0:
		animation_player.play("pressed_up")
		relased.emit()



