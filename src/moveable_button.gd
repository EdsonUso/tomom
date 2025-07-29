extends AreaItem 
class_name MovableButton


var is_movable: bool = true
var is_on_ground: bool = true

@onready var area_de_clique: Area2D = $AreaDeClique


func _ready() -> void:
	super._ready() 
	area_de_clique.input_event.connect(_on_clique_mouse)


func _on_clique_mouse() -> void:
	if not is_on_ground:
		return

	GerenciadorFios.botao_ativado(self)


func on_pickup() -> void:
	is_on_ground = false
	# Esconde o prompt de interação.
	interaction_prompt.hide()

func on_drop() -> void:
	is_on_ground = true
