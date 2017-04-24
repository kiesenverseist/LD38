extends RigidBody2D

export var speed = 100

var move = Vector2()

var inventory = {

}

var buildings = {
	empty    = 0,
	core     = 0,
	struct   = 0,
	drone    = 0,
	power    = 0,
	workshop = 0,
	life     = 0,
	port     = 0
}

onready var components = {
	empty    = [0                                                       , "empty"    ],
	core     = [preload("res://inst_scenes/ship/ship_core.tscn")        , "core"     ],
	struct   = [preload("res://inst_scenes/ship/structural_module.tscn"), "struct"   ],
	drone    = [preload("res://inst_scenes/ship/drone_control.tscn")    , "drone"    ],
	power    = [preload("res://inst_scenes/ship/power_module.tscn")     , "power"    ],
	workshop = [preload("res://inst_scenes/ship/workshop.tscn")         , "workshop" ],
	life     = [preload("res://inst_scenes/ship/life_support.tscn")     , "life"     ],
	port     = [preload("res://inst_scenes/ship/drone_port.tscn")       , "port"     ]
}

var grid = []
var grid_dimensions = Vector2(99,99) #has to be odd
var grid_center = (grid_dimensions - Vector2(1, 1))/2

var cell_size = 32

func _ready():
	set_inertia(.7)
	set_process(true)
	set_fixed_process(true)
	
	#create the grid for all the values
	for x in range(grid_dimensions.x):
		grid.append([])
		for y in range(grid_dimensions.y):
			grid[x].append(null)
	
	#shp core
	var component = components.core[0].instance()
	add_child(component)
	grid[grid_center.x][grid_center.y] = [component, components.core[1]]
	
	#drone control
	component = components.drone[0].instance()
	add_child(component)
	grid[grid_center.x + 1][grid_center.y - 1] = [component, components.drone[1]]
	
	#workshop
	component = components.workshop[0].instance()
	add_child(component)
	grid[grid_center.x - 1][grid_center.y - 1] = [component, components.workshop[1]]
	
	#power
	component = components.power[0].instance()
	add_child(component)
	grid[grid_center.x - 1][grid_center.y + 1] = [component, components.power[1]]
	
	#drone port
	component = components.port[0].instance()
	add_child(component)
	grid[grid_center.x + 1][grid_center.y + 1] = [component, components.port[1]]
	
	grid[grid_center.x + 1][grid_center.y] = components.empty
	grid[grid_center.x - 1][grid_center.y] = components.empty
	

func _process(delta):
	
	for i in buildings:
		buildings[i] = 0
	
	for x in range(grid_dimensions.x):
		for y in range(grid_dimensions.y): #cycle through everything in the grid
			
			var component = grid[x][y]
			
			if component != null:
				buildings.empty += 1
				
				if component[1] == components.core[1]:
					buildings.core += 1
				elif component[1] == components.struct[1]:
					buildings.struct += 1
				elif component[1] == components.drone[1]:
					buildings.drone += 1
				elif component[1] == components.power[1]:
					buildings.power += 1
				elif component[1] == components.workshop[1]:
					buildings.workshop += 1
				elif component[1] == components.life[1]:
					buildings.life += 1
				elif component[1] == components.port[1]:
					buildings.port += 1
				
				
				var pos = (Vector2(x, y) - grid_center) * cell_size
				
				if typeof(component[0]) == TYPE_OBJECT:
					component[0].set_pos(pos)
				
				get_node("TileMap").set_tile(pos, "add")
	
	set_mass(buildings.empty * 2)

func _fixed_process(delta):
	
	get_node("/root/Node").warp(self)
	
	if get_node("/root/Node").controlling == "ship":
		move = Vector2()
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
		
		move = move.rotated(get_rot())
		
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

func get_nearest(pos, thing):
	var num_cells = grid_dimensions.x * grid_dimensions.y
	var count = 0
	
	var record = grid_dimensions.length()
	var record_holder = Vector2(0,0)
	
	while count <= num_cells - 1:
		var c_pos = Vector2()
		
		c_pos.x = count % int(grid_dimensions.x)
		c_pos.y = floor(count / (grid_dimensions.y))
		
		var dist = grid_dimensions.length()
		
		if thing == null:
			if grid[c_pos.x][c_pos.y] == null:
				dist = (pos - c_pos).length()
		else:
			if grid[c_pos.x][c_pos.y] != null:
				if grid[c_pos.x][c_pos.y][1] == thing:
					dist = (pos - c_pos).length()
		
		if dist < record:
			record = dist
			print(record)
			record_holder = c_pos
		
		count += 1
	
	return record_holder