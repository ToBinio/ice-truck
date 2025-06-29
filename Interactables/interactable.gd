extends Node
class_name Interactable

@export var texture: Texture2D
@export var broken_texture: Texture2D

@export var highlight_texture: Texture2D

@export var wrench_ingredient: BasicIngredient

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var overlay: Sprite2D = %Overlay
@onready var broken: Sprite2D = %Broken

@onready var repair_stream_player: AudioStreamPlayer = $RepairStreamPlayer
@onready var audio_stream_player: AudioStreamPlayer = %InteractStreamPlayer

var _can_interact = false
@export var is_broken = false
@export var can_break = false

func _process(_delta: float) -> void:
	if is_broken:
		sprite_2d.texture = broken_texture
	else:
		sprite_2d.texture = texture
	
	if _can_interact:
		overlay.texture = highlight_texture
	else:
		overlay.texture = null
		
	broken.visible = is_broken
	
	_can_interact = false

func interact(player: Player) -> bool:
	audio_stream_player.play()
	
	if(is_broken and player.item and player.item.basic == wrench_ingredient):
		repair_stream_player.play()
		is_broken = false
		player.item = null
		return true
	
	return false
	
func try_interact(player: Player):
	_can_interact = can_interact(player)

func can_interact(player: Player):
	if(is_broken and player.item and player.item.basic == wrench_ingredient):
		return true
	
	if (is_broken):
		return false
		
	return null
