extends RigidBody2D

var speed = 200

func _ready():
	set_fixed_process(true)
	set_inertia(0.5)
	get_node("../Camera2D").following = self

func _fixed_process(delta):
	var move = Vector2()
	var rot = 0
	
	if Input.is_action_pressed("move_up"):
		move += Vector2(0, -1)
	if Input.is_action_pressed("move_right"):
		rot += 1
	if Input.is_action_pressed("move_down"):
		move += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		rot -= 1

	move = move.rotated(get_rot())
	
	set_applied_force(move * speed)
	set_applied_torque(rot)
