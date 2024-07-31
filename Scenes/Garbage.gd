extends ItemList

signal remove_item_sig


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _can_drop_data(at_position, data):
	if data is CodeNode:
		return true


func _drop_data(at_position, data):
	if data is CodeNode:
		emit_signal("remove_item_sig", data.item)
