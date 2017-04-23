extends Node

var controlling = "player"
onready var player = get_node("Ship/player")

onready var drone_pk = preload("res://inst_scenes/drone.tscn")
var drone = null

onready var asteroid_pk = preload("res://inst_scenes/asteroid.tscn")

func _ready():
	set_process_input(true)
	set_process(true)
	add_child(asteroid_pk.instance())

func _process(delta):
	if randi()%10 == 1:
		add_child(asteroid_pk.instance())
	

func _input(event):
	if event.is_action_pressed("interact") && !event.is_echo():
		if player.cur_room == get_node("Ship").components.core[1]:
			if controlling == "player":
				controlling = "ship"
				get_node("Camera2D").following = get_node("Ship")
			elif controlling == "ship":
				controlling = "player"
				get_node("Camera2D").following = get_node("Ship/player")
		
		if player.cur_room == get_node("Ship").components.drone[1]:
				if controlling == "player":
					controlling = "drone"
					drone(true)
				elif controlling == "drone":
					controlling = "player"
					get_node("Camera2D").following = get_node("Ship/player")
					drone(false)

func drone(toggle):
	if toggle:
		drone = drone_pk.instance()
		add_child(drone)
	else:
		drone.queue_free()
		drone = null
