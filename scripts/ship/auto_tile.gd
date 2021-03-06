extends TileMap

#information is tabulated as follows:
#surrounding information : shape , x-flip, y-flip, transpose

var map_info = {
	0  : [0, false, false, false],
	1  : [4, false, true , false],
	2  : [4, true , false, true ],
	3  : [2, true , true , false],
	4  : [4, false, false, true ],
	5  : [2, false, true , false],
	6  : [3, false, false, true ],
	7  : [1, false, true , false],
	8  : [4, false, false, false],
	9  : [3, false, false, false],
	10 : [2, true , false, false],
	11 : [1, true , false, true ],
	12 : [2, false, false, false],
	13 : [1, false, false, true ],
	14 : [1, false, false, false],
	15 : [5, false, false, false],
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_tile(pos, type):
	var mpos = world_to_map(pos)
	var base = map_info[0]
	
	if type == "remove":
		set_cellv(mpos, -1, false, false, false)
	elif type == "add":
		set_cellv(mpos, base[0], base[1], base[2], base[3])
	
	update_tiles(mpos.x, mpos.y)

func update_tiles(i, j):
	update_tile(i, j)
	update_tile(i, j + 1)
	update_tile(i, j - 1)
	update_tile(i + 1, j)
	update_tile(i + 1, j + 1)
	update_tile(i + 1, j - 1)
	update_tile(i - 1, j)
	update_tile(i - 1, j + 1)
	update_tile(i - 1, j - 1)
	

#func update_all():
#	for i in range(tw):
#		for j in range(th):
#			if get_cell(i, j) != -1:
#				update_tile(i, j)

func update_tile(i, j):
	if get_cell(i, j) != -1:
		var tid = get_surroundings(i, j)
		set_tile_shape(i, j, tid)

func get_surroundings(i, j):
	var tid = 0
	
	tid += (get_cell(i, j - 1) != -1) * 1
	tid += (get_cell(i - 1, j) != -1) * 2
	tid += (get_cell(i + 1, j) != -1) * 4
	tid += (get_cell(i, j + 1) != -1) * 8
	
	return tid

func set_tile_shape(i, j, tid):
	
	var tile = map_info[tid]
	
	set_cell(i, j, tile[0], tile[1], tile[2], tile[3])