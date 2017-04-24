extends RigidBody2D

var speed = 200

var bullet_pk = preload("res://inst_scenes/bullet.tscn")


const max_charge = 60
var charge = max_charge
var p_charge = 0
var est_time = 0
const drain_rate = 1 #per second

var inventory = {

}

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	set_process(true)
	
	set_inertia(0.5)
	get_node("../Camera2D").following = self
	
	var pos = Vector2()
	pos = get_node("/root/Node/Ship").get_nearest(get_node("/root/Node/Ship/player").g_pos, get_node("/root/Node/Ship").components.port[1])
	pos = get_node("/root/Node/Ship").get_nearest(pos, null) - get_node("/root/Node/Ship").grid_center
	pos = (pos * get_node("/root/Node/Ship").cell_size).rotated(get_node("/root/Node/Ship").get_rot()) + get_node("/root/Node/Ship").get_pos() 
	
	set_pos(pos)
	

func _process(delta):
	charge -= drain_rate * delta
	est_time = charge / drain_rate
	p_charge = charge / max_charge * 100
	

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT:
			var b = bullet_pk.instance()
			get_node("/root/Node").add_child(b)
			b.set_rot(get_rot())
			b.set_pos(get_global_pos())
			b.apply_impulse(Vector2(0, 0), Vector2(1000, 0).rotated(get_rot() + PI/2))

func _fixed_process(delta):
	
	get_node("/root/Node").warp(self)
	
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
	
	var ship_dir = PI + get_angle_to(get_node("../Ship").get_pos())
	get_node("CanvasLayer/Polygon2D").set_rot(ship_dir)
	get_node("CanvasLayer/Polygon2D").set_pos(get_viewport_rect().size/2)
	
