extends Node


func _on_start_button_pressed() ->void:
	get_tree().change_scene_to_file("res://scenes/room.tscn")

func _on_quit_button_pressed() ->void:

	#Fecha a aplicação do jogo
	get_tree().quit()
