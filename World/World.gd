extends Node2D

var selected_entity: KinematicBody2D
var entity_direction: Vector2

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_point(event.position)
			if result == [] and selected_entity != null:
				selected_entity.state = selected_entity.state_enum.Follow
				selected_entity.direction = event.position - selected_entity.position
			for dictionary in result:
				if dictionary.collider is KinematicBody2D:
					selected_entity = dictionary.collider
					print(selected_entity)
