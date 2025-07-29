extends StaticBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer 
@onready var colisor: CollisionShape2D = $CollisionShape2D

##Quantos botões referenciados a esta porta precisam estar ativados para que ela possa abrir
@export var ativacoes_necessarias: int = 1

var is_open: bool = false
var ativacoes_atuais: int = 0

##Aumenta a quantidade de ativações feitas
func receber_ativacao() -> void:
	ativacoes_atuais += 1

	if ativacoes_atuais == ativacoes_necessarias and not is_open:
		_open_door()


func receber_desativacao() -> void:
	ativacoes_atuais = max(0, ativacoes_atuais -1)
	print("Porta recebeu desativação.")

	if ativacoes_atuais < ativacoes_necessarias:
		_close_door()


func _open_door() -> void:
	if animation_player.is_playing():
		return

	print("Porta recebendo comando de abrir")
	animation_player.play("open")
	is_open = true


func _close_door() -> void:
	if not is_open: 
		return 

	is_open = false
	animation_player.play("close")
	colisor.disabled = false;