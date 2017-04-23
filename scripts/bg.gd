extends Node2D

onready var children = get_children()
var p_pos = Vector2(0,0)

func _ready():
	arrange_bg(get_node("../Camera2D"))

func arrange_bg(obj):
	
	var amount = 3000
	
	var t_pos = obj.get_global_pos()
	t_pos.x = floor(t_pos.x / amount) * amount
	t_pos.y = floor(t_pos.y / amount) * amount
	
	if p_pos != t_pos:
		children[0].set_pos(t_pos)
		children[1].set_pos(t_pos + Vector2(amount, 0))
		children[2].set_pos(t_pos + Vector2(-amount, 0))
		children[3].set_pos(t_pos + Vector2(0, amount))
		children[4].set_pos(t_pos + Vector2(0, -amount))
		children[5].set_pos(t_pos + Vector2(amount, amount))
		children[6].set_pos(t_pos + Vector2(-amount, amount))
		children[7].set_pos(t_pos + Vector2(amount, -amount))
		children[8].set_pos(t_pos + Vector2(-amount, -amount))
		p_pos = t_pos
