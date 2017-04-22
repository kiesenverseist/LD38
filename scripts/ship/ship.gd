extends RigidBody2D

export var speed = 100

onready var components = {
	core = preload("res://inst_scenes/ship/ship_core.tscn"),
	struct = preload("res://inst_scenes/ship/structural_module.tscn"),
	empty = 0
}

var grid = []
var grid_dimensions = Vector2(100,100) #has to be odd
var grid_center = (grid_dimensions - Vector2(1, 1))/2

var cell_size = 32

func _ready():
	set_inertia(1)
	set_process(true)
	set_fixed_process(true)
	
	#create the grid for all the values
	for x in range(grid_dimensions.x):
		grid.append([])
		for y in range(grid_dimensions.y):
			grid[x].append(null)
	
	var component = components.core.instance()
	add_child(component)
	grid[grid_center.x][grid_center.y] = component
	

func _process(delta):	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var pos = get_local_mouse_pos()
		pos = (pos + Vector2(cell_size/2,cell_size/2)) / cell_size + grid_center
		if pos.x >= 0 && pos.y >= 0 && pos.x < grid_dimensions.x && pos.y < grid_dimensions.y:
			if grid_is_placeable(pos):
#				var component = components.struct.instance()
#				add_child(component)
				grid[pos.x][pos.y] = components.empty
	
	for x in range(grid_dimensions.x):
		for y in range(grid_dimensions.y): #cycle through everything in the grid
			
			var component = grid[x][y]
			
			if component != null:
				var pos = (Vector2(x, y) - grid_center) * cell_size
				
				if typeof(component) == TYPE_OBJECT:
					component.set_pos(pos)
				
				get_node("TileMap").set_tile(pos, "add")

func _fixed_process(delta):
	var move = Vector2()
	var rot = 0
	
	if Input.is_action_pressed("move_up"):
		move += Vector2(0, -1)
	if Input.is_action_pressed("move_right"):
		move += Vector2(1, 0)
	if Input.is_action_pressed("move_down"):
		move += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		move += Vector2(-1, 0)
	
	if Input.is_action_pressed("rot_cw"):
		rot += 1
	if Input.is_action_pressed("rot_ccw"):
		rot -= 1
	
	set_applied_force(move * speed)
	set_applied_torque(rot)

func grid_is_placeable(pos):
	if grid[pos.x][pos.y] != null:
		return false
	elif pos.y-1 >= 0 && grid[pos.x][pos.y - 1] != null:
		return true
	elif pos.y+1 <= grid_dimensions.y && grid[pos.x][pos.y + 1] != null:
		return true
	elif pos.x-1 >= 0 && grid[pos.x- 1][pos.y] != null:
		return true
	elif pos.x+1 <= grid_dimensions.x && grid[pos.x + 1][pos.y] != null:
		return true
	else:
		return false
