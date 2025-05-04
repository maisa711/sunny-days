extends Node2D

var speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() < 0.5:
		speed = 0
	else:
		speed = randi_range(20, 45)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if speed != 0:
		position.x -= speed * delta
