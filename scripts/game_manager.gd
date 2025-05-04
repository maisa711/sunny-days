extends Node

# preload obstacles
const Assets = preload("uid://cclwr1y4l04jh")
var ground_obs := [Assets.MUSHROOM, Assets.MUSHROOM_BIG, Assets.MUSHROOM_FLAT, Assets.ROCK, Assets.STUMP]
var sky_obs := [Assets.EAGLE]

# variables
var difficulty := 0
var current_obs : Array
var last_obs

# imports
@onready var player: CharacterBody2D = $"../Player"
@onready var ground_layer: TileMapLayer = $"../Layers/Platforms"
@onready var obs_parent: Node = $"../Obstacles"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	print(difficulty)


# called when new game starts
func new_game():
	difficulty = 0
	Global.points = 0
	Global.game_running = false
	Hud.reset_ui()
	GameOver.hide()
	
	for obs in current_obs:
		obs.queue_free()
	for child in obs_parent.get_children():
		child.queue_free()
	current_obs.clear()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# if game is running start the actions
	if Global.game_running:

		adjust_difficulty()
		generate_obs()
		
		# move the ground position 
		if player.position.x - ground_layer.position.x > Global.SCREEN_SIZE.x - 84:
			ground_layer.position.x += Global.SCREEN_SIZE.x
		
		# remove obstacles that are off screen
		for obs in current_obs:
			if obs.position.x < (player.position.x - Global.SCREEN_SIZE.x):
				remove_obs(obs)
		# add points and update hud
		Global.points = int(player.position.x / 2)
		Hud.update_points_label()
	else:
		# if jump is pressed start the game
		if Input.is_action_pressed("jump"):
			Global.game_running = true
			Hud.hide_ui()
	
	
func add_star() -> void:
	Global.stars += 1
	Hud.update_stars_label()
	
	
func generate_obs():
	# if there are no ostacles or last obstacle is far enough generate obs
	if current_obs.is_empty() or last_obs.position.x < player.position.x + randi_range(30, 100):
		var obs
		var max_obs = difficulty + 1

		for i in range(randi_range(1, max_obs)):
				var add_x : int = (i * 170)
				var add_y: int = 0
				obs = add_obs(ground_obs, obs, add_x, add_y)
				last_obs = obs
		
		# at max difficulty generate birds at 50% chance
		if difficulty == Global.MAX_DIFFICULTY:
			if randf() > 0.5:

				var add_x = 0
				var add_y = + randi_range(Global.BIRD_HEIGHTS[0], Global.BIRD_HEIGHTS[1])
				obs = add_obs(sky_obs, obs, add_x, add_y)

# adds an obstacle to the scene
func add_obs(obs_type, obs, x, y):
	var obs_scene = obs_type.pick_random()
	obs = obs_scene.instantiate()
	
	var obs_x : int = Global.SCREEN_SIZE.x + player.position.x + randi_range(70, 140) + x
	var obs_y: int = obs.position.y + 16 + y
	
	obs.position = Vector2i(obs_x, obs_y)
	
	obs_parent.add_child(obs)
	current_obs.append(obs)
	
	return obs

# removes an obstacle from the scene
func remove_obs(obs):
	obs.queue_free()
	obs_parent.remove_child(obs)
	current_obs.erase(obs)

# adjusts difficulty based on the score
func adjust_difficulty():

	difficulty = int(Global.points / Global.POINTS_MODIFIER)
	Global.player_speed = Global.START_SPEED + Global.points / Global.SPEED_MODIFIER
	
	if Global.player_speed > Global.MAX_SPEED:
		Global.player_speed = Global.MAX_SPEED
	
	if difficulty > Global.MAX_DIFFICULTY:
		difficulty = Global.MAX_DIFFICULTY
