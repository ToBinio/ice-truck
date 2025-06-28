extends Node
class_name Interactable

@export var texture: Texture2D
@export var highlight_texture: Texture2D

@onready var sprite_2d: Sprite2D = %Sprite2D

var _can_interact = false

func _process(_delta: float) -> void:
	if _can_interact:
		sprite_2d.texture = highlight_texture
		sprite_2d.z_index = 0
	else:
		sprite_2d.texture = texture
		sprite_2d.z_index = -1
		
	_can_interact = false

func interact(_player: Player):
	printerr("Interact funktion not overwritten!")
	
func try_interact(player: Player):
	_can_interact = can_interact(player)

func can_interact(_player: Player) -> bool:
	printerr("can_interact funktion not overwritten!")
	return false
