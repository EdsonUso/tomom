extends CharacterBody2D

class_name Player

@export_group("Movement")
@export var speed: float = 300.0
@export_range(0.0, 1.0) var friction: float = 0.1
@export_range(0.0, 1.0) var acceleration: float = 0.2

@export_group("Juice")
@export var enable_rotation_juice: bool = true
@export_range(0.0, 0.1) var rotation_smoothing: float = 0.1
@export var enable_squash_juice: bool = true
@export var squash_factor: float = 0.1

@export_group("Grab & Drop")
var item_in_reach: AreaItem = null
var carried_item: AreaItem = null

var has_wire: bool = false
var is_in_wiring_mode: bool = false
var first_button_to_connect: Node = null
var was_moving: bool = false

const wire_scene = preload("res://wire.tscn")

@onready var wire_line_preview: Line2D = $WireLinePreview
@onready var dust_particles: GPUParticles2D = $dust_particles
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $Colisor
@onready var interaction_area: Area2D = $interaction_area
@onready var pickup_item_sound: AudioStreamPlayer = $PickupItem

func _ready() -> void:
	await get_tree().process_frame

	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)

	if collision and collision.shape:
		var half_height = collision.shape.get_rect().size.y / 2.0
		dust_particles.position.y = half_height

	wire_line_preview.visible = false
	wire_line_preview.width = 3.0
	wire_line_preview.default_color = Color.RED


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interagir"):
		if not carried_item and is_instance_valid(item_in_reach):
			if item_in_reach.item_id == "wire_roll":
				has_wire = true
				item_in_reach.queue_free()
			else:
				carried_item = item_in_reach
				item_in_reach = null
				carried_item.reparent(self)
				carried_item.get_node("Colisor").disabled = true
				carried_item.position = Vector2(0, -40)
				pickup_item_sound.play()
				
				if carried_item.has_method("on_pickup"):
					carried_item.on_pickup()

	if event.is_action_pressed("drop_item"):
		if is_instance_valid(carried_item):
			var item_to_drop = carried_item
			
			self.remove_child(item_to_drop)
			get_tree().current_scene.add_child(item_to_drop)
			item_to_drop.global_position = self.global_position
			item_to_drop.get_node("Colisor").disabled = false
			
			if item_to_drop.has_method("on_drop"):
				item_to_drop.on_drop()
			
			carried_item = null
	
	if has_wire and event.is_action_pressed("toggle_wiring_mode"):
		print("botão de toggle ativado!")
		is_in_wiring_mode = !is_in_wiring_mode
		if not is_in_wiring_mode:
			first_button_to_connect = null
			wire_line_preview.visible = false

	if is_in_wiring_mode and event is InputEventMouseButton and event.is_pressed():
		handle_wiring_click(event.position)


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
	was_moving = is_moving
	
	move_and_slide()
	apply_juice_effects(input_direction)
	
	if is_in_wiring_mode and is_instance_valid(first_button_to_connect):
		wire_line_preview.global_position = Vector2.ZERO
		wire_line_preview.points[0] = first_button_to_connect.global_position
		wire_line_preview.points[1] = get_global_mouse_position()


func handle_wiring_click(mouse_position: Vector2):
	var world_space = get_world_2d().direct_space_state
	var query_params = PhysicsRayQueryParameters2D.create(get_global_mouse_position(), get_global_mouse_position())
	var result = world_space.intersect_point(query_params, 1)

	if result.is_empty():
		return

	var clicked_node = result[0].collider
	if not clicked_node.is_in_group("connectable"):
		return

	if not is_instance_valid(first_button_to_connect):
		first_button_to_connect = clicked_node
		wire_line_preview.points = [first_button_to_connect.global_position, get_global_mouse_position()]
		wire_line_preview.visible = true
	else:
		var second_button = clicked_node
		if second_button != first_button_to_connect:
			first_button_to_connect.set_linked_button(second_button)
			second_button.set_linked_button(first_button_to_connect)
			create_permanent_wire(first_button_to_connect, second_button)
			
			has_wire = false
			is_in_wiring_mode = false
			first_button_to_connect = null
			wire_line_preview.visible = false


func create_permanent_wire(button_a, button_b) -> void:
	var wire_instance = wire_scene.instantiate()
	get_tree().current_scene.add_child(wire_instance)
	wire_instance.points = [button_a.global_position, button_b.global_position]
	wire_instance.width = 5.0
	wire_instance.default_color = Color.GREEN


func apply_juice_effects(input_dir: Vector2) -> void:
	if enable_rotation_juice and velocity.length() > 10:
		var target_angle = velocity.angle() + PI / 2
		sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_smoothing)

	if enable_squash_juice:
		var squash_intensity = velocity.length() / speed
		var squash_amount = 1.0 - squash_intensity * squash_factor
		var stretch_amuount = 1.0 + squash_intensity * squash_factor
		var target_scale = Vector2(stretch_amuount, squash_amount)
		
		if input_dir == Vector2.ZERO:
			target_scale = Vector2.ONE
		
		sprite.scale = sprite.scale.lerp(target_scale, 0.1)


func emit_dust_particles() -> void:
	if velocity.length() > 0:
		dust_particles.rotation = velocity.angle() - PI
		dust_particles.emitting = true


func _on_interaction_area_entered(area: AreaItem) -> void:
	if area.is_in_group("coletaveis"):
		item_in_reach = area


func _on_interaction_area_exited(area: AreaItem) -> void:
	if area == item_in_reach:
		item_in_reach = null
