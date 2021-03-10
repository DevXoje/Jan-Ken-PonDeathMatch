extends Sprite

onready var piedra_texture = load('res://Sprites/icon-rock.png')
onready var papel_texture = load('res://Sprites/icon-paper.png')
onready var tijera_texture = load('res://Sprites/icon-scissors.png')
onready var spock_texture = load('res://Sprites/icon-spock.png')
onready var lizard_texture = load('res://Sprites/icon-lizard.png')


enum weapon_texture {Piedra, Papel, Tijera, Spock, Lizard}

var weapon : int
var beats = []

func _ready():
	change_texture(len(weapon_texture)-1)


func change_texture(new_weapon):
	beats.clear()
	match new_weapon:
		weapon_texture.Piedra:
			texture = piedra_texture
			beats.append(weapon_texture.Lizard)
			beats.append(weapon_texture.Tijera)
		weapon_texture.Papel:
			texture = papel_texture
			beats.append(weapon_texture.Spock)
			beats.append(weapon_texture.Piedra)
		weapon_texture.Tijera:
			texture = tijera_texture
			beats.append(weapon_texture.Lizard)
			beats.append(weapon_texture.Papel)
		weapon_texture.Spock:
			texture = spock_texture
			beats.append(weapon_texture.Piedra)
			beats.append(weapon_texture.Tijera)
		weapon_texture.Lizard:
			texture = lizard_texture
			beats.append(weapon_texture.Spock)
			beats.append(weapon_texture.Papel)
	weapon = new_weapon

