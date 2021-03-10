extends KinematicBody2D


onready var weapon_node = $weapon_container/weapon


enum state_enum {Wander, Attacking, Fighting, Follow}
enum weapon {Piedra, Papel, Tijera}

var state = state_enum.Wander setget change_state

var speed = 100
var direction = Vector2.ZERO
var objective: KinematicBody2D

signal weapon_changed
signal died


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			#change_weapon()
			#weapon_node.change_texture(1)
			print(weapon_node.weapon)


func _ready():
	randomize()


func _physics_process(delta):
	match state:
		state_enum.Wander:
			move(delta)
		state_enum.Attacking:
			chase(delta)
		state_enum.Fighting:
			pass
		state_enum.Follow:
			move(delta)


func move(delta):
	move_and_collide(direction.normalized()*speed*delta)
	position.x = clamp(position.x, 32, directions.screensize_x-32)
	position.y = clamp(position.y, 32, directions.screensize_y-32)


func chase(delta):
	if objective == null:
		return
	direction = objective.position - position
	move(delta)


func wander():
	direction = directions.random_direction()


func change_weapon():
	weapon_node.change_texture(randi() % len(weapon_node.weapon_texture))
	emit_signal("weapon_changed", self)
	check_attack()


func _on_wanderTimer_timeout():
	if $wanderTimer.wait_time == 3:
		direction = Vector2.ZERO
		change_weapon()
		$wanderTimer.wait_time = 2
	else:
		$wanderTimer.wait_time = 3
		wander()


func attack(body: KinematicBody2D):
	for weapon in weapon_node.beats:
		if body.weapon_node.weapon == weapon:
			objective = body
			change_state(state_enum.Attacking)


func fight(body):
	change_state(state_enum.Fighting)
	for weapon in weapon_node.beats:
		if body.weapon_node.weapon == weapon:
			change_state(state_enum.Wander)
			body.die()
		elif weapon == weapon_node.weapon:
			print("putada", self)
			die()
		else:
			print("EMPATE")
	change_state(state_enum.Wander)
	


func check_attack():
	if check_fight():
		return
	for area in $vision.get_overlapping_areas():
		var body = area.get_parent()
		if body is KinematicBody2D:
			attack(body)


func check_fight():
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if body is KinematicBody2D and area.name == "hitbox":
			fight(body)
			return true
	return false


func die():
	emit_signal("died", self)
	$anim.play("Death")


func enemy_weapon_changed(enemy: KinematicBody2D):
	check_attack()
	print("VAMOS ATACA", enemy)


func enemy_died(enemy):
	if enemy == objective:
		change_state(state_enum.Wander)


func _on_anim_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()


func _on_vision_area_entered(area):
	var body = area.get_parent()
	if body is KinematicBody2D and not body == self:
		connect("weapon_changed", body, "enemy_weapon_changed")
		connect("died", body, "enemy_died")
		check_attack()


func _on_vision_area_exited(area):
	var body = area.get_parent()
	disconnect("weapon_changed", body, "enemy_weapon_changed")
	disconnect("died", body, "enemy_died")


func _on_hitbox_area_entered(area):
	if area.name != "vision":
		var body = area.get_parent()
		check_fight()


func change_state(new_state: int):
	if new_state == state_enum.Wander:
		$wanderTimer.start()
		direction = Vector2.ZERO
	else:
		$wanderTimer.stop()
	state = new_state
