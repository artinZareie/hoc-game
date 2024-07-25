extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func create_drag_icon(selected_index: int) -> TextureRect:
	var icon = TextureRect.new()
	icon.texture = get_item_icon(selected_index)
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	
	if (fixed_icon_size != Vector2i.ZERO):
		icon.size = fixed_icon_size
		icon.size.x = fixed_icon_size.x
		icon.size.y = fixed_icon_size.y
		print(fixed_icon_size)
		print("--------------------")
		print(icon.size)

	return icon


func _get_drag_data(at_position) -> int:
	var selected_item = get_selected_items()
	
	set_drag_preview(create_drag_icon(selected_item[0]))
	
	return selected_item[0]
