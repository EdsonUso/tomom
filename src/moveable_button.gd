extends AreaItem

class_name MovableButton

signal pressed
signal released

var is_activated: bool = false
var is_on_ground: bool = true # O botão começa no chão
var linked_button: Node = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Conecta o sinal do próprio Area2D (que ele herda de Item)
	# para detectar quando o jogador pisa nele.
	self.body_entered.connect(_on_body_entered)
	# self.body_exited.connect(_on_body_exited) # Para lógica de resetar

func _on_body_entered(body):
	# O botão só funciona se estiver no chão E não tiver sido ativado permanentemente.
	if not is_on_ground or is_activated:
		return
	
	if body.is_in_group("player"):
		activate()

# --- Funções Públicas ---

func activate():
	if is_activated: return
	is_activated = true
	animation_player.play("press_down")
	pressed.emit()
	if is_instance_valid(linked_button):
		linked_button.force_activate()

func force_activate():
	if is_activated: return
	is_activated = true
	animation_player.play("press_down")

func set_linked_button(button_node: Node):
	linked_button = button_node

# --- Funções para o Player Chamar ---

func on_pickup():
	"""Chamada pelo jogador quando este item é pego."""
	is_on_ground = false
	# Esconde a linha de conexão se houver uma
	# (lógica de fio visual pode ser adicionada aqui)

func on_drop():
	"""Chamada pelo jogador quando este item é solto."""
	is_on_ground = true
