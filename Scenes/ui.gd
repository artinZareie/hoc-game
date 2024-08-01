extends CanvasLayer


func _on_play_pressed():
	var player = get_parent().get_child(0).get_child(0)
	player.execute()
