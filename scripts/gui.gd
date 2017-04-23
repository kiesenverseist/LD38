extends ReferenceFrame

func _ready():
	set_process(true)

func _process(delta):
	var info_text = "Current Room: " + get_node("/root/Node/Ship/player").cur_room
	info_text += "\nCurrently Controlling: " + get_node("/root/Node").controlling
	
	get_node("info").set_text(info_text)