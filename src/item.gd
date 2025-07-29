extends Area2D

class_name AreaItem

@export var item_id:StringName = "icone_familia"

@onready var interaction_prompt: Node2D = $InteractionPrompt

func _ready() -> void:
	interaction_prompt.hide()

func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		interaction_prompt.show()

func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interaction_prompt.hide()
