extends Node2D

class_name BotaoBase

@export var alvos: Array[NodePath]

@export var ativar_uma_vez: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_activated: bool = false

var parceiros_conectados: Array[BotaoBase] = []


func adicionar_parceiro(parceiro: BotaoBase) -> void:
	if not parceiros_conectados.has(parceiro):
		print("Adicionando parceiro...", parceiro)
		parceiros_conectados.append(parceiro)
		print("Parceiros conectados: ", parceiros_conectados)


func ativar_localmente() -> void:
	if ativar_uma_vez and is_activated:
		return

	_ativar_alvos()


func ativar_remotamente()-> void:
	_ativar_alvos_remotamente()


func _ativar_alvos_remotamente() -> void:
	if ativar_uma_vez and is_activated:
		print("botão", self.name, "já esta ativado")
		return

	if not is_activated:
		animation_player.play("press_down")

	for alvo_path in alvos:
		var alvo_node = get_node_or_null(alvo_path)
		if is_instance_valid(alvo_node) and alvo_node.has_method("receber_ativacao"):
			alvo_node.receber_ativacao()
		else:
			print("Alvo inválido ou sem metodo")
		is_activated = true
		

func _ativar_alvos() -> void:
	print("Ativando alvos")
	if ativar_uma_vez and is_activated:
		print("botão", self.name, "já esta ativado")
		return

	if not is_activated:
		animation_player.play("press_down")

	for parceiro in parceiros_conectados:
		print("Ativando ", parceiro, " remotamente...")
		parceiro.ativar_remotamente()

	for alvo_path in alvos:
		var alvo_node = get_node_or_null(alvo_path)
		if is_instance_valid(alvo_node) and alvo_node.has_method("receber_ativacao"):
			alvo_node.receber_ativacao()
		else:
			print("Alvo inválido ou sem metodo")

func desativar_localmente() -> void:
	_desativar_alvos()


func desativar_remotamente() -> void:
	_desativar_alvos()


func _desativar_alvos() -> void:
	if ativar_uma_vez:
		return

	if is_activated:
		animation_player.play("press_up") 
		is_activated = false

		for alvo_path in alvos:
			var alvo_node = get_node_or_null(alvo_path)
			if is_instance_valid(alvo_node) and alvo_node.has_method("receber_desativacao"):
				alvo_node.receber_desativacao()
