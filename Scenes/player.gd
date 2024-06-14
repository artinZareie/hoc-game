extends CharacterBody2D

const SPEED = 300.0
const BLOCKSIZE = 32

@export var direction: int = 0

var instruction_queue = []
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

func _physics_process(delta):
	self.rotation = PI / 2 * direction
	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
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
		on_process = true
	if on_process:
		var destination_distance = abs(destination[0] - self.position.x) + abs(destination[1] - self.position.y)
		if (destination_distance < 4):
			self.position.x = destination[0]
			self.position.y = destination[1]
			on_process = false
			instruction = 0
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


