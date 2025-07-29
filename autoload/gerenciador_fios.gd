# gerenciador_fios.gd
extends Node2D

enum Estado { OCIOSO, CRIANDO_FIO }

var estado_atual: Estado = Estado.OCIOSO
var primeiro_botao: Node2D = null
var jogador: Player

var fio_temporario: Line2D
var fios_permanentes: Array = []


func _ready() -> void:
	fio_temporario = Line2D.new()
	fio_temporario.width = 5.0
	fio_temporario.default_color = Color.YELLOW
	fio_temporario.joint_mode = Line2D.LINE_JOINT_ROUND
	fio_temporario.end_cap_mode = Line2D.LINE_CAP_BOX
	add_child(fio_temporario)


func _process(_delta: float) -> void:
	# 1. Gerencia o fio de preview (durante a criação)
	if estado_atual == Estado.CRIANDO_FIO:
		if is_instance_valid(primeiro_botao):
			fio_temporario.clear_points()
			fio_temporario.add_point(primeiro_botao.global_position)
			fio_temporario.add_point(get_global_mouse_position())
		return

	for fio in fios_permanentes:
		if fio.tem_ponta_movel:
			var no_movel = fio.no_a if fio.no_a.get("is_movable") else fio.no_b
			if not no_movel.get("is_on_ground"):
				fio.atualizar_posicao_dinamica(jogador.global_position)
			else:
				fio.atualizar_posicao()


func botao_ativado(botao: Node2D) -> void:
	match estado_atual:
		Estado.OCIOSO:
			print("Primeiro botão selecionado. Iniciando criação do fio.")
			estado_atual = Estado.CRIANDO_FIO
			primeiro_botao = botao
			fio_temporario.visible = true

		Estado.CRIANDO_FIO:
			if botao == primeiro_botao:
				print("Mesmo botão selecionado. Ação cancelada.")
				return

			print("Segundo botão selecionado. Criando fio permanente.")
			criar_fio_permanente(primeiro_botao, botao)
			estado_atual = Estado.OCIOSO
			primeiro_botao = null

			fio_temporario.clear_points()
			fio_temporario.visible = false


func criar_fio_permanente(botao_node_a: BotaoBase, botao_node_b: BotaoBase) -> void:
	print("Iniciando metodo para criação de fio permanente")
	var cena_fio: Wire = preload("res://wire.tscn").instantiate()
	fios_permanentes.append(cena_fio)

	get_tree().root.add_child(cena_fio)
	cena_fio.configurar(botao_node_a, botao_node_b)

	if botao_node_a is BotaoBase and botao_node_b is BotaoBase:
		botao_node_a.adicionar_parceiro(botao_node_b)
		botao_node_b.adicionar_parceiro(botao_node_a)

func registrar_jogador(player: Player) -> void:
	jogador = player