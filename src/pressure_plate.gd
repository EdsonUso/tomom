# PressurePlate.gd
extends BotaoBase 
class_name Pressure

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Jogador pisou na placa de pressão.")
		_ativar_alvos()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		print("Jogador saiu da placa de pressão.")
		_desativar_alvos()