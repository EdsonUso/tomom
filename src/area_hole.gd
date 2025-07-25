extends Area2D

class_name AreaHole

@export var required_item_id: StringName = "icone_familia"

#Sinal será emitido quando o item correto for entregue
signal item_delivered(message) #Eu te amo sinais eu te amo

func _on_body_entered(body: Player) -> void:
	if not body.is_in_group("player"):
		return 

	if not is_instance_valid(body.carried_item):
		return 

	if body.carried_item.item_id == required_item_id:
		print("Entrega correta!")

		$PlacementSFX.play()

		print("Emitindo o sinal item_delivered!")

		item_delivered.emit("Este é o item correto...")

		body.carried_item.queue_free() # tapoha

		body.carried_item = null


		# Desativa a colisão do buraco
		get_node("CollisionShape2D").disabled = true

