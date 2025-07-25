extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label
@onready var timer: Timer = Timer.new() 

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var full_text: String = ""
var current_char_index: int = 0

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)


func start_cutscene(message: String) -> void:
	full_text = message
	current_char_index = 0
	label.text = ""

	timer.wait_time = 0.05 
	timer.start()


	self.show()

	animation_player.play("cutscene")

func _on_timer_timeout() ->  void:
	if current_char_index < full_text.length():
		current_char_index += 1;
		label.text = full_text.substr(0, current_char_index)

	else:
		timer.stop()
		
