extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const diff = 32
var direction_sig = []
var on_process = false
var instruction_dir = [ 0, 0 ]
var destination = []
@export var direction: int = 0

func move_right():
	direction_sig.push_back([ 1, 0 ])
	
func move_left():
	direction_sig.push_back([ -1, 0 ])
	
func move_up():
	direction_sig.push_back([ 0, -1 ])

func move_down():
	direction_sig.push_back([ 0, 1 ])
	
func turn_clockwise():
	direction_sig.push_back([ 2, 0 ])
	
func turn_counter():
	direction_sig.push_back([ 0, 2 ])
	
func move_forward():
	direction_sig.push_back([ 1, 1 ])

func _physics_process(delta):
	if not on_process and direction_sig.size() > 0:
		instruction_dir = direction_sig.pop_front()
		
		var dirX = instruction_dir[0]
		var dirY = instruction_dir[1]
		
		if dirX == 1 and dirY == 0:
			destination = [ position.x + diff, 0 ]
		elif dirX == -1 and dirY == 0:
			destination = [ position.x - diff, 0 ]
		elif dirX == 0 and dirY == 1:
			destination = [ position.x, position.y + diff ]
		elif dirX == 0 and dirY == -1:
			destination = [ position.x, position.y - diff ]
		
		on_process = true
	
	if on_process:
		pass
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
	if directionX:
		velocity.x = directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
