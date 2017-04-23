extends Camera2D

var zoom = Vector2(0.3,0.3)
onready var following = get_node("../Ship/player")

func _ready():
	set_process(true)

func _process(delta):
	
	if following != null:
		set_pos(following.get_global_pos())
		set_rot(following.get_global_rot())
	
#	if Input.is_key_pressed(KEY_SHIFT):
	if Input.is_key_pressed(KEY_PAGEUP):
		zoom /= 1.1
	if Input.is_key_pressed(KEY_PAGEDOWN):
		zoom *= 1.1
	
	zoom.x = clamp(zoom.x, 0.1, 2)
	zoom.y = clamp(zoom.y, 0.1, 2)
	
	set_zoom(zoom)
	
	get_node("../bg").arrange_bg(self)
	
	