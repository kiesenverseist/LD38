extends KinematicBody2D

export var speed = 1
var g_pos = Vector2()
var cur_room = null

func _ready():
	set_fixed_process(true)
	set_process(true)

func _process(delta):
	var pos = get_pos()
	
	g_pos.x = floor((pos.x + get_parent().cell_size/2) / get_parent().cell_size) + get_parent().grid_center.x
	g_pos.y = floor((pos.y + get_parent().cell_size/2) / get_parent().cell_size) + get_parent().grid_center.y
	
	cur_room = get_parent().grid[g_pos.x][g_pos.y][1]

func _fixed_process(delta):
	
	if get_node("/root/Node").controlling == "player":
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
		
		if move != Vector2():
			get_node("Sprite").set_rot(move.angle() - PI/2)
		
		var dir = get_global_rot()
		
		move = move.rotated(dir)
		
		var over = move(move)
		
		if is_colliding():
			move(get_collision_normal().slide(over))
