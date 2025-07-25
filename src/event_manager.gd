extends Node

const EVENT_DATA = {
	"familia_cutscene": {
		"type": "cutscene",
		"message": "Você desbloqueou uma memorias de familia",
		"animation_in": "cutscene_familia",
	},
	"animal_cutscene": {
		"type": "cutscene",
		"message": "Você desbloqueou memoria dos seus pets!",
		"animation_in": "cutscene_animais"
	},
	"relacionamento_cutscene": {
		"type": "cutscene",
		"message": "Você desbloqueou uma memorias do seu relacionamento!",
		"animation_in": "cutscene_relacionamento",
	},
	"viagem_cutscene": {
		"type": "cutscene",
		"message": "Você desbloqueou memorias das suas viagens!",
		"animation_in": "cutscene_viagens"
	}
}

static func get_event_data(event_id: String) -> Dictionary:
	if EVENT_DATA.has(event_id):
		return EVENT_DATA[event_id]

	push_error("Erro: Evento com ID:", event_id, " nao encontrado!")
	return {}