extends Node

onready var screensize_x = ProjectSettings.get_setting("display/window/size/width")
onready var screensize_y = ProjectSettings.get_setting("display/window/size/height")

func random_direction():
	var num = randi() % 8 
	var random_direction: Vector2
	
	match num:
		0:
			random_direction = Vector2.RIGHT
		1:
			random_direction = Vector2.LEFT
		2:
			random_direction = Vector2.UP
		3:
			random_direction = Vector2.DOWN
		4:
			random_direction = Vector2(1,1)
		5:
			random_direction = Vector2(-1,1)
		6:
			random_direction = Vector2(1,-1)
		7:
			random_direction = Vector2(-1,-1)
	
	return random_direction



