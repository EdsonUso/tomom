extends BotaoBase

class_name ConnectableButton

@onready var area_clique: Area2D = $AreaDeClique
@onready var area_ativacao: Area2D = $AreaAtivacao

func _ready() -> void:
	area_clique.input_event.connect(_on_area_clique_input_event)
	area_ativacao.body_entered.connect(_on_body_entered)
	area_ativacao.body_exited.connect(_on_body_exited)


func _on_area_clique_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		GerenciadorFios.botao_ativado(self)


func ativar_por_conexao() -> void:
	_ativar_alvos()

func _on_body_entered(body: Node2D) -> void:
	ativar_localmente()

func _on_body_exited(body: Node2D) -> void:
	if ativar_uma_vez:
		return

	desativar_localmente()

