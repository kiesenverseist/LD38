extends RigidBody2D

export var speed = 100

onready var components = {
	struct = preload("res://inst_scenes/ship/structural_module.tscn") 
}

func _ready():
	set_process(true)
	set_fixed_process(true)

func _process(delta):
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var pos = get_local_mouse_pos()
		var component = components.struct.instance()
		add_child(component)
		component.set_pos(pos)
	
	var modules = get_children()
	
	for module in modules:
		var pos = module.get_pos()
		pos.x = int(pos.x) / 32 *32
		pos.y = int(pos.y) / 32 *32
		module.set_pos(pos)

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
