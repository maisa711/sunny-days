extends CanvasLayer

# when reset button is pressed reset scene
func _on_button_pressed() -> void:
	Hud.update_high_score_label()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
