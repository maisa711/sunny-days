extends CharacterBody2D

# imports
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var running: AudioStreamPlayer2D = $running
@onready var jump: AudioStreamPlayer2D = $jump

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		
		# if released early jump less
		if Input.is_action_pressed("jump") and velocity.y < 0:
			velocity += get_gravity() * delta * 0.8
		else:
			velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	if Global.game_running:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = Global.JUMP_VELOCITY
			animated_sprite.play("jump")
			jump.play()
		
		# play animations based on actions
		if is_on_floor():
			animated_sprite.play("walk")
			
			if not running.playing:
				running.play()
				
		else:
			if running.playing:
				running.stop()
			animated_sprite.play("fall")
		
		# Apply movement
		velocity.x = Global.player_speed
		
		
		# if moving right speed up, if left slow down
		if direction > 0:
			velocity.x = move_toward(velocity.x, velocity.x * 1.5, Global.player_speed)
		elif direction < 0:
			velocity.x = move_toward(velocity.x, velocity.x / 1.5, Global.player_speed)

		move_and_slide()
	
	else:
		animated_sprite.play("idle")
