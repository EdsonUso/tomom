extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label
@onready var timer: Timer = Timer.new() 
@onready var end_delay_timer: Timer =  Timer.new()
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var current_event_data: Dictionary

var full_text: String = ""
var current_char_index: int = 0

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)

	add_child(end_delay_timer)
	end_delay_timer.one_shot = true
	end_delay_timer.timeout.connect(play_fade_out)


func start_cutscene(event_id: String, location_node:Node2D) -> void:
	print("Start cutscene chamada")
	var data: Dictionary = EventManager.get_event_data(event_id)

	if data.is_empty():
		print("Dados de cutscene em branco")
		return
	
	current_event_data = data

	var anim_in_name = data.get("animation_in", "cutsceve_blah") #show cutscene é um valor padrão caso a chave não exista no dicionario (bem confuso)

	self.show()

	animation_player.play(anim_in_name)
	
	full_text = data.get("message", "...")
	current_char_index = 0
	label.text = ""

	timer.wait_time = 0.05 
	timer.start()	

func _on_timer_timeout() ->  void:
	if current_char_index < full_text.length():
		current_char_index += 1;
		label.text = full_text.substr(0, current_char_index)

	else:
		timer.stop()
		end_delay_timer.start(3.0) #3 Segundos com o texto na tela
		

func play_fade_out() -> void:
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "fade_out":
		self.hide()
		current_event_data.clear()

