extends Area2D


@onready var timer: Timer = $Timer

# when player killed stop the game
func _on_body_entered(body: Node2D) -> void:
	#body.get_node("CollisionShape2D").queue_free()
	Global.game_running = false
	get_tree().paused = true
	GameOver.show()
