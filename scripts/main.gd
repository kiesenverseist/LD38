extends Node

var controlling = "player"
onready var player = get_node("Ship/player")

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("interact") && !event.is_echo():
		if player.cur_room == get_node("Ship").components.core[1]:
			if controlling == "player":
				controlling = "ship"
			elif controlling == "ship":
				controlling = "player"
				