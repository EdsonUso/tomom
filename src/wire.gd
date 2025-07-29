# Fio.gd
extends Node2D

class_name Wire

@onready var line_2d: Line2D = $Line2D

var no_a: Node2D
var no_b: Node2D
var tem_ponta_movel: bool = false

func configurar(p_no_a: Node2D, p_no_b: Node2D) -> void:
	no_a = p_no_a
	no_b = p_no_b

	if (no_a.has_method("get") and no_a.get("is_movable")) or \
	   (no_b.has_method("get") and no_b.get("is_movable")):
		tem_ponta_movel = true

	atualizar_posicao()

func atualizar_posicao() -> void:
	line_2d.clear_points()
	line_2d.add_point(no_a.global_position)
	line_2d.add_point(no_b.global_position)

func atualizar_posicao_dinamica(posicao_dinamica: Vector2) -> void:
	line_2d.clear_points()

	if no_a.has("is_moveable") and no_a.is_moveable:
		line_2d.add_point(posicao_dinamica)
		line_2d.add_point(no_b.global_position)
	else:
		line_2d.add_point(no_a.global_position)
		line_2d.add_point(posicao_dinamica)

	