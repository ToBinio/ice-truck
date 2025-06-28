extends Node2D
class_name Item

@export var resource: ItemResource

func _ready() -> void:
	for index in range(resource.ice.size()): 
		var ingredient = resource.ice[index]
		match index:
			0: _display_ingredient(ingredient.level1_texture)
			1: _display_ingredient(ingredient.level2_texture)
			2: _display_ingredient(ingredient.level3_texture)

	if(resource.base):
		_display_ingredient(resource.base.model_texture)
	
	if(resource.basic):
		_display_ingredient(resource.basic.model_texture)

func _display_ingredient(texture: Texture2D):
	var sprite = Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)
