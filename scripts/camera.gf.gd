extends Camera2D

var zoom = Vector2(0.3,0.3)
onready var following = get_node("../Ship/player")

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom /= 1.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			zoom *= 1.1
		
		zoom.x = clamp(zoom.x, 0.1, 2)
		zoom.y = clamp(zoom.y, 0.1, 2)
		
		set_zoom(zoom)
	

func _process(delta):
	
	if following != null:
		set_pos(following.get_global_pos())
		set_rot(following.get_global_rot())
	
	get_node("../bg").arrange_bg(self)
	