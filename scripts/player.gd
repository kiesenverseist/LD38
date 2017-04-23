extends KinematicBody2D

export var speed = 1

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var move = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		move += Vector2(0, -1)
	if Input.is_action_pressed("ui_right"):
		move += Vector2(1, 0)
	if Input.is_action_pressed("ui_down"):
		move += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		move += Vector2(-1, 0)
	
	move = move.normalized() * speed
	
	var dir = get_global_rot() - get_rot()
	
	move = move.rotated(dir)

	move(move)
