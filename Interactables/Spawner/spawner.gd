extends Interactable

@export var ingredient: Ingredient
@onready var ingredient_sprite: Sprite2D = %Ingredient

func _ready() -> void:
	ingredient_sprite.texture = ingredient.texture

func interact(player: Player):
	if player.item:
		return
		
	var item = ItemResource.new()
	item.ingredients.push_back(ingredient)
	
	player.item = item
