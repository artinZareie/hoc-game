class_name CodeNode
extends Object

var item: TreeItem
var type: String
var post_else: TreeItem


func _init(p_item: TreeItem, p_type: String, p_else: TreeItem = null):
	item = p_item
	type = p_type
	post_else = p_else
