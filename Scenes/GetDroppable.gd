extends VBoxContainer

var statements: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if (data is int):
		return true
	return false


func _drop_data(at_position: Vector2, data: Variant):
	statements.push_back(data)
	#print_debug(statements)
