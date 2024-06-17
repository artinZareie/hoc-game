extends CharacterBody2D

const SPEED = 100.0
const ANGULAR_SPEED = 5.0
const BLOCKSIZE = 32
const ANGULAR_EPS = PI/ 36
# Atlas (1, 0) corresponds to wall
const WALL_ATLAS_COORDS = [1, 0]
const WATER_ATLAS_COORDS = [3, 0]

@export var direction: int = 0

@onready var tilemap: TileMap = get_parent() as TileMap

var instruction_queue = [3, 3, 3, 1, 3, 3, 3, 1, 3, 3, 3, 3, 2, 3, 3, 2, 3, 3, 3, 1, 3]
var on_process = false
var instruction = 0
var destination = []

func move_right():
	instruction_queue.push_back(4)
	
func move_left():
	instruction_queue.push_back(5)
	
func move_up():
	instruction_queue.push_back(6)

func move_down():
	instruction_queue.push_back(7)
	
func turn_clockwise():
	instruction_queue.push_back(1)
	
func turn_counter():
	instruction_queue.push_back(2)
	
func move_forward():
	instruction_queue.push_back(3)
	
func is_atlas_wall(atlas):
	return atlas[0] == WALL_ATLAS_COORDS[0] and atlas[1] == WALL_ATLAS_COORDS[1]
	
func is_atlas_water(atlas):
	return atlas[0] == WATER_ATLAS_COORDS[0] and atlas[1] == WATER_ATLAS_COORDS[1]
	
func win_operation():
	print("You won!")
	get_tree().paused = true

func _ready():
	# Checking if parent is actually a TileMap
	if not tilemap:
		print("Invalid Parent!")

func _physics_process(delta):
	self.rotation = lerp_angle(self.rotation, PI / 2 * direction, ANGULAR_SPEED * delta)
	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
	
	var curr_cell_coords = tilemap.local_to_map(self.position)
	var curr_cell_atlas = tilemap.get_cell_atlas_coords(0, curr_cell_coords)
	if is_atlas_water(curr_cell_atlas):
		win_operation()
	
	if not on_process and instruction_queue.size() > 0:
		instruction = instruction_queue.pop_front()
		destination = [self.position.x, self.position.y]
		
		match instruction:
			1:
				direction = (direction + 1) % 4
			2:
				direction = (direction + 3) % 4
			3:
				match direction:
					0: destination[1] -= BLOCKSIZE
					1: destination[0] += BLOCKSIZE
					2: destination[1] += BLOCKSIZE
					3: destination[0] -= BLOCKSIZE
			4: destination[0] += BLOCKSIZE
			5: destination[0] -= BLOCKSIZE
			6: destination[1] -= BLOCKSIZE
			7: destination[1] += BLOCKSIZE
		
		var run_into_wall: bool = false
		
		if instruction != 0 and instruction != 1 and instruction != 2:
			var cell_coords = tilemap.local_to_map(Vector2(destination[0], destination[1]))
			var cell_atlas = tilemap.get_cell_atlas_coords(0, cell_coords)
			if cell_atlas != null and is_atlas_wall(cell_atlas):
				run_into_wall = true
		
		if not run_into_wall:
			on_process = true
		
	if on_process:
		var destination_distance = abs(destination[0] - self.position.x) + abs(destination[1] - self.position.y)
		if destination_distance < 4 and instruction != 1 and instruction != 2:
			self.position.x = destination[0]
			self.position.y = destination[1]
			on_process = false
			instruction = 0
		elif (instruction == 1 or instruction == 2) and (abs(self.rotation - PI / 2 * direction) < ANGULAR_EPS):
			on_process = false
		else:
			match instruction:
				3:
					match direction:
						0: directionY = -1
						1: directionX = 1
						2: directionY = 1
						3: directionX = -1
	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
