extends RigidBody2D

var shape = Vector2Array()

func _ready():
	for i in range(10):
		var v = Vector2(rand_range(10, 20), 0)
		v = v.rotated(2*PI/10*i)
		shape.append(v)
	
	get_node("Polygon2D").set_polygon(shape)
	get_node("CollisionPolygon2D").set_polygon(shape)
	
	var p_ang = get_angle_to(get_node("/root/Node/Ship").get_global_pos()) - PI/2
	
	apply_impulse(Vector2(), Vector2(500, 0).rotated(rand_range(p_ang - PI/3, p_ang + PI/3)))
	
