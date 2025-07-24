extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 300.0

@export_range(0.0, 1.0) var friction: float = 0.1 ## Quão rapido o jogador para
@export_range(0.0, 1.0) var acceleration: float = 0.2 ##Quã rapido a velocidade aumenta

@export_group("Juice")
@export var enable_rotation_juice: bool = true
@export_range(0.0, 0.1) var rotation_smoothing: float = 0.1 ## Suavidade na rotação

@onready var dust_particles: GPUParticles2D = $dust_particles

var was_moving: bool = false

@export var enable_squash_juice: bool = true
@export var squash_factor: float = 0.1 ## Quão forte é o efeito de "achatar"

@onready var sprite: Sprite2D = $Sprite2D

@onready var collision:CollisionShape2D = $Colisor

func _ready() -> void:
	await get_tree().process_frame #Espera para garantir que o shape foi inicializado

	if collision and collision.shape:
		var half_height = collision.shape.get_rect().size.y / 2.0
		dust_particles.position.y = half_height
		print("Posição do emissor de poeira ajustada para: ", dust_particles.position)




func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var target_velocity: Vector2 = input_direction * speed


	if input_direction != Vector2.ZERO:
		velocity = velocity.lerp(target_velocity, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)

	var is_moving: bool = velocity.length() > 1.0

	if is_moving and not was_moving:
		emit_dust_particles()

	move_and_slide()

	apply_juice_effects(input_direction)


func apply_juice_effects(input_dir: Vector2) -> void:
	
	if enable_rotation_juice and velocity.length() > 10:
		var target_angle = velocity.angle() + PI / 2 # Adiciona 90 graus(PI/2 radianos) para alinhar o sprite
		sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_smoothing)

	if enable_squash_juice:
		var squash_intensity = velocity.length() / speed
		var squash_amount = 1.0 - squash_intensity * squash_factor
		var stretch_amuount = 1.0 + squash_intensity * squash_factor

		var target_scale = Vector2(stretch_amuount, squash_amount)
		if input_dir == Vector2.ZERO:
			target_scale ==  Vector2.ONE # Retorna o tamanho normal quando parado

		sprite.scale = sprite.scale.lerp(target_scale, 0.1)

func emit_dust_particles() -> void:
	if velocity.length() > 0:
		dust_particles.rotation = velocity.angle() - PI

		dust_particles.emitting = true
