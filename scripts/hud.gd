extends CanvasLayer


@onready var points_label: Label = $Control/Points
@onready var high_score_label: Label = $Control/HighScore
@onready var start_label: Label = $Control/Start
@onready var instructions_label: RichTextLabel = $Control/Instructions

func update_points_label() -> void:
	points_label.text = "Points: " + str(Global.points)
	
func update_high_score_label() -> void:
	if Global.points > Global.high_score:
		Global.high_score = Global.points
		high_score_label.text = "High Score: " + str(Global.high_score)

func hide_ui() -> void:
	start_label.hide()
	instructions_label.hide()

func reset_ui() -> void:
	start_label.show()
	instructions_label.show()
	points_label.text = "Points: 0" 
