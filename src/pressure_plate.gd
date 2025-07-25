extends ConnectableButton

class_name Pressure


func _on_body_entered(body: Player) -> void:

	if is_activated:
		return

	animation_player.play("press_down")
	pressed.emit()
	is_activated = true