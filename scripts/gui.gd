extends ReferenceFrame

onready var root = get_node("/root/Node")

func _ready():
	set_process(true)

func _process(delta):
	var info_text = "Current Room: " + get_node("/root/Node/Ship/player").cur_room
	info_text += "\nCurrently Controlling: " + get_node("/root/Node").controlling
	
	get_node("info").set_text(info_text)
	
	if root.controlling == "drone":
		get_node("drone").set_hidden(false)
		get_node("drone/EnergyBar").set_value(root.drone.p_charge)
		get_node("drone/EnergyBar/est_time").set_text("%s s" % round(root.drone.est_time))
	else:
		get_node("drone").set_hidden(true)
	
	if root.controlling == "ship":
		get_node("ship").set_hidden(false)
	else:
		get_node("ship").set_hidden(true)
	
	if root.controlling == "build":
		get_node("build").set_hidden(false)
	else:
		get_node("build").set_hidden(true)