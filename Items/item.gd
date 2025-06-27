extends Node2D
class_name Item

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var resource: ItemResource

func _ready() -> void:
	if(resource and resource.ingredients[0]):
		sprite_2d.texture = resource.ingredients[0].texture
