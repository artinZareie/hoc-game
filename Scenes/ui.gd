extends CanvasLayer


func _on_play_pressed():
	var player = get_node("../level_container/level/Player")
	print_debug(player)
	player.execute()
