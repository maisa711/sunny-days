extends Node

# Variables
var points: int = 0
var stars: int = 0
var high_score: int = 0
var player_speed := 150.0
var game_running := false

# Constants

# Screen
const SCREEN_SIZE := Vector2i(320, 180)

# Player
const START_SPEED := 150.0
const MAX_SPEED := 400
const SPEED_MODIFIER := 20
const JUMP_VELOCITY := -300.0

# Obstacles
const BIRD_HEIGHTS := [-80, -90]

# Game
const MAX_DIFFICULTY : int = 2
const POINTS_MODIFIER := 1000
