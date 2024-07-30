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


func _get_drag_data(at_position) -> CodeNode:
	var item = get_item_at_position(at_position)
	var item_type = node_types[item]
	var else_node = null
	
	if (item_type == 'if'):
		else_node = if_else[item]
	
	if (item_type == 'else'):
		item_type = 'if'
		else_node = item
		item = else_node.get_prev()
	
	var code_node = CodeNode.new(item, item_type, else_node)
	
	return code_node


func _is_upper_equal(upper: TreeItem, lower: TreeItem) -> bool:
	if upper == lower:
		return true
	
	var current_item = lower
	while current_item:
		if current_item == upper:
			return true
		current_item = current_item.get_parent()
	return false


func _can_have_child(item: TreeItem) -> bool:
	var type = node_types[item]
	
	return type == 'if' or type == 'else'


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if (data is InventoryDrag):
		var drop_section := get_drop_section_at_position(at_position)
		var item := get_item_at_position(at_position)
		
		if drop_section == 0 and not _can_have_child(item):
			return false
				
		if drop_section == 0 and \
			node_types[item] == 'else' and false:
				return false
		if drop_section == 1 and not _is_throwable_after(item) or\
			drop_section == -1 and not _is_throwable_before(item):
				return false
		
		return true
	
	if (data is CodeNode):
		var drop_section := get_drop_section_at_position(at_position)
		var item := get_item_at_position(at_position)
	
		if drop_section == 0 and not _can_have_child(item):
				return false
				
		if drop_section == 0 and \
			node_types[item] == 'else' and false:
				return false
		
		if _is_upper_equal(data.item, item):
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


func _create_node(parent: TreeItem, text: String, type: String) -> TreeItem:
	var new_node = create_item(parent)
	new_node.set_text(0, text)
	node_types[new_node] = type
	return new_node


func _is_throwable_after(item: TreeItem) -> bool:
	var type = node_types[item]
	return type != 'if'

func _is_throwable_before(item: TreeItem) -> bool:
	var type = node_types[item]
	return type != 'else'


func _insert_single_declarative(item: TreeItem, drag_section: int,
									text: String, type: String) -> void:
	if drag_section == -100:
		var new_node = _create_node(tree_root, 
			text,
			type)
	
	elif node_types[item] == 'empty':
		_change_empty(item, text, type, drag_section)
		
	elif drag_section == 1 and _is_throwable_after(item):
		var new_node = _create_node(tree_root, 
			text,
			type)
		_insert_after(item, new_node)
		
	elif drag_section == -1 and _is_throwable_before(item):
		var new_node = _create_node(tree_root, 
			text,
			type)
		_insert_before(item, new_node)
		
	elif drag_section == 0 and \
		(node_types[item] == 'if' or node_types[item] == 'else'):
		var new_node = _create_node(item, 
			text,
			type)


func _drop_data(at_position: Vector2, data: Variant):
	if data is InventoryDrag:
		var drag_section = get_drop_section_at_position(at_position)
		var item := get_item_at_position(at_position)
	
		match data.data:
			InventoryDrag.Statements.ROTATE_CLOCKWISE:
				_insert_single_declarative(item, drag_section,
											"rotate_clockwise()", "rotate_clockwise")
					
			InventoryDrag.Statements.ROTATE_COUNTERCLOCKWISE:
				_insert_single_declarative(item, drag_section,
											"rotate_counterclockwise()", 
											"rotate_counterclockwise")
				
			InventoryDrag.Statements.PRINT:
				_insert_single_declarative(item, drag_section,
											"print('hello world')", 
											"print")
			
			InventoryDrag.Statements.IF:
				if drag_section == -100:
					var new_node_if = _create_node(tree_root, 
						"if true", 
						"if")
					
					#var empty_if = create_item(new_node_if)
					#node_types[empty_if] = "empty"
					
					var new_node_else = _create_node(tree_root, 
						"else", 
						"else")
					if_else[new_node_if] = new_node_else
					
					#var empty_else = create_item(new_node_else)
					#node_types[empty_else] = "empty"
				elif node_types[item] == 'empty' and drag_section == 0:
					_change_empty(item, "if true", "if", drag_section)
					var new_node_if = item
					
					#var empty_if = create_item(new_node_if)
					#node_types[empty_if] = "empty"
					
					var new_node_else = _create_node(tree_root, 
						"else", 
						"else")
					_insert_after(new_node_if, new_node_else)
					if_else[new_node_if] = new_node_else
					
					#var empty_else = create_item(new_node_else)
					#node_types[empty_else] = "empty"
				
				elif drag_section == 1:
					# TODO: Insert the new node after item.
					var new_node_if = _create_node(tree_root, 
						"if true", 
						"if")
					_insert_after(item, new_node_if)
						
					var new_node_else = _create_node(tree_root, 
						"else", 
						"else")
					_insert_after(new_node_if, new_node_else)
					if_else[new_node_if] = new_node_else
				
				elif drag_section == -1:
					var new_node_if = _create_node(tree_root, 
						"if true", 
						"if")
					_insert_before(item, new_node_if)
						
					var new_node_else = _create_node(tree_root, 
						"else", 
						"else")
					_insert_after(new_node_if, new_node_else)
					if_else[new_node_if] = new_node_else
					
				elif drag_section == 0 and \
					(node_types[item] == 'if' or node_types[item] == 'else'):
					var new_node_if = _create_node(item, 
						"if true", 
						"if")
					
					#var empty_if = create_item(new_node_if)
					#node_types[empty_if] = "empty"
					
					var new_node_else = _create_node(item, 
						"else", 
						"else")
					if_else[new_node_if] = new_node_else
					
					#var empty_else = create_item(new_node_else)
					#node_types[empty_else] = "empty"
					
			_:
				return
