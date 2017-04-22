extends RigidBody2D

var speed = 100

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var move = Vector2()
	
	if Input.is_action_pressed("move_up"):
		move += Vector2(0, -1)
	if Input.is_action_pressed("move_right"):
		move += Vector2(1, 0)
	if Input.is_action_pressed("move_down"):
		move += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		move += Vector2(-1, 0)
	
	set_applied_force(move * speed)
	
	print(move)
