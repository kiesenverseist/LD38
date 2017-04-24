extends Node2D

var speed = 2
var selected = null

onready var ship = get_node("../Ship")
onready var buttons = get_node("../CanvasLayer/gui area/build/VButtonArray")

onready var map = {
	0 : ship.components.empty,
	1 : ship.components.life,
	2 : ship.components.drone,
	3 : ship.components.port,
	4 : ship.components.power,
	5 : ship.components.core,
	6 : ship.components.workshop
}

func _ready():
	set_process(true)
	
	get_node("../Camera2D").following = self

func _process(delta):
	
	#building stuffs
	selected = buttons.get_selected()
	selected = map[selected]
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var pos = ship.get_local_mouse_pos()
		pos = (pos + Vector2(ship.cell_size, ship.cell_size)/2) / ship.cell_size + ship.grid_center
		if pos.x >= 0 && pos.y >= 0 && pos.x < ship.grid_dimensions.x && pos.y < ship.grid_dimensions.y:
			if selected == map[0]:
				if ship.grid_is_placeable(pos):
					ship.grid[pos.x][pos.y] = selected
			elif ship.grid[pos.x][pos.y] == ship.components.empty:
				var component = selected[0].instance()
				ship.add_child(component)
				ship.grid[pos.x][pos.y] = [component, selected[1]]
	
	#movement
	var move = Vector2()
		
	if Input.is_action_pressed("move_up"):
		move += Vector2(0, -1)
	if Input.is_action_pressed("move_right"):
		move += Vector2(1, 0)
	if Input.is_action_pressed("move_down"):
		move += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		move += Vector2(-1, 0)
	
	move = move.normalized() * speed
	
	if Input.is_key_pressed(KEY_SHIFT):
		move *= 3

	set_pos(get_pos() + move)