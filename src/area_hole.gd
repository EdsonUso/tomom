extends Area2D

class_name AreaHole # Agora este nome não faz mais sentido, mas infelizmente a godot não atualiza referencias automaticamente

@export var required_item_id: StringName = "icone_familia" ##O id do item 
@export var event: String ##O nome do evento a ser disparado
@export var filled_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

#Sinal será emitido quando o item correto for entregue
signal item_delivered(event_id, location_node) #Eu te amo sinais eu te amo

func _on_body_entered(body: Player) -> void:


	if not is_instance_valid(body.carried_item):
		return 

	if body.carried_item.item_id == required_item_id:
		print("Entrega correta!")

		$PlacementSFX.play()

		print("Emitindo o sinal item_delivered!")

		item_delivered.emit(event, self)

		body.carried_item.queue_free() # tapoha

		body.carried_item = null

		if filled_texture:
			sprite.texture = filled_texture

		# Desativa a colisão do buraco
		get_node("CollisionShape2D").disabled = true