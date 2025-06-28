extends Interactable

@export var ingredient: Ingredient
@onready var ingredient_sprite: Sprite2D = %Ingredient

func _ready() -> void:
	ingredient_sprite.texture = ingredient.icon_texture

func interact(player: Player):
	if super(player):
		return
	
	if player.item:
		return
		
	var item = ItemResource.from_ingredient(ingredient)
	player.item = item

func can_interact(player: Player):
	if super(player) != null:
		return super(player)
	
	return player.item == null;
