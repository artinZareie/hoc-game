extends TileMap

var grnd = Vector2i(0, 0)
var wall = Vector2i(1, 0)
var lava = Vector2i(2, 0)
var watr = Vector2i(3, 0)

var test_level = [
	[wall, wall, wall, wall, wall, wall, wall, wall, wall, wall],
	[wall, grnd, grnd, grnd, wall, wall, grnd, grnd, watr, wall],
	[wall, grnd, wall, grnd, wall, wall, grnd, wall, wall, wall],
	[wall, grnd, wall, grnd, wall, wall, grnd, grnd, grnd, wall],
	[wall, grnd, wall, grnd, wall, wall, wall, wall, grnd, wall],
	[wall, grnd, wall, grnd, grnd, grnd, grnd, grnd, grnd, wall],
	[wall, wall, wall, wall, wall, wall, wall, wall, wall, wall]	
]

func load_test_level():
	for i in range(0, 10):
		for j in range(0, 6):
			self.set_cell(0, Vector2i(i,j),  0, test_level[j][i])

func load_level(level_number):
	if (level_number == 0):
		load_test_level()

func _ready():
	load_level(0)



func _process(delta):
	pass
