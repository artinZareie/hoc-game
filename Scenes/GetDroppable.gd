extends Tree

var tree_root: TreeItem
@export var node_types: Dictionary
@export var if_else: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	tree_root = self.create_item()
	self.hide_root = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _get_drag_data(at_position) -> int:
	var item = get_item_at_position(at_position)
	
	return 0


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if (data is InventoryDrag):
		var drop_section := get_drop_section_at_position(at_position)
		var item := get_item_at_position(at_position)
		
		if drop_section == 0 and \
		( \
			node_types[item] == 'print' or \
			node_types[item] == 'turn_clockwise' or \
			node_types[item] == 'turn_counterclockwise' \
			):
				return false
		
		return true
	return false


func _change_empty(item: TreeItem, text: String, type: String, drag_section: int) -> void:
	item.set_text(0, text)
	node_types[item] = type


func _insert_before(item: TreeItem, new_node: TreeItem) -> void:
	new_node.move_before(item)


func _insert_after(item: TreeItem, new_node: TreeItem) -> void:
	new_node.move_after(item)


func _drop_data(at_position: Vector2, data: Variant):
	if data is InventoryDrag:
		var drag_section = get_drop_section_at_position(at_position)
		var item := get_item_at_position(at_position)
	
		match data.data:
			InventoryDrag.Statements.ROTATE_CLOCKWISE:
				if drag_section == -100:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "rotate_clockwise()")
					node_types[new_node] = "rotate_clockwise"
				elif node_types[item] == 'empty':
					_change_empty(item, "rotate_clockwise()", "rotate_clockwise", drag_section)
				elif drag_section == 1:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "rotate_clockwise()")
					node_types[new_node] = "rotate_clockwise"
					_insert_after(item, new_node)
				elif drag_section == -1:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "rotate_clockwise()")
					node_types[new_node] = "rotate_clockwise"
					_insert_before(item, new_node)
					
			InventoryDrag.Statements.ROTATE_COUNTERCLOCKWISE:
				if drag_section == -100:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "rotate_counterclockwise()")
					node_types[new_node] = "rotate_counterclockwise"
				elif node_types[item] == 'empty':
					_change_empty(item, "rotate_counterclockwise()", "rotate_counterclockwise", drag_section)
				elif drag_section == 1:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "rotate_counterclockwise()")
					node_types[new_node] = "rotate_counterclockwise"
					_insert_after(item, new_node)
				elif drag_section == -1:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "rotate_counterclockwise()")
					node_types[new_node] = "rotate_counterclockwise"
					_insert_before(item, new_node)
				
			InventoryDrag.Statements.PRINT:
				if drag_section == -100:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "print('hello world')")
					node_types[new_node] = "print"
				elif node_types[item] == 'empty':
					_change_empty(item, "print('hello world')", "print", drag_section)
				elif drag_section == 1:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "print('hello world')")
					node_types[new_node] = "print"
					_insert_after(item, new_node)
				elif drag_section == -1:
					var new_node = create_item(tree_root)
					new_node.set_text(0, "print('hello world')")
					node_types[new_node] = "print"
					_insert_after(item, new_node)
				
			InventoryDrag.Statements.IF:
				if drag_section == -100:
					var new_node_if = create_item(tree_root)
					new_node_if.set_text(0, "if true")
					node_types[new_node_if] = "if"
					
					var empty_if = create_item(new_node_if)
					node_types[empty_if] = "empty"
					
					var new_node_else = create_item(tree_root)
					new_node_else.set_text(0, "else")
					node_types[new_node_else] = "else"
					if_else[new_node_if] = new_node_else
					
					var empty_else = create_item(new_node_else)
					node_types[empty_else] = "empty"
				elif node_types[item] == 'empty' and drag_section == 0:
					# TODO: replace empty block with if
					pass
				elif drag_section == 1:
					# TODO: Insert the new node after item.
					pass
				elif drag_section == -1:
					# TODO: Insert the new node before item.
					pass
					
			_:
				return
