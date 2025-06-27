extends Resource
class_name ItemResource

@export var ingredients: Array[Ingredient] = []

const SCENE = preload("res://Items/Item.tscn")

static func combine(a: ItemResource, b: ItemResource) -> ItemResource:
	var item = ItemResource.new()
	
	item.ingredients.append_array(a.ingredients)
	item.ingredients.append_array(b.ingredients)
	
	return item

func valid() -> bool:
	if (_count_ingredient(Ingredient.TYPE.BASE) > 1):
		return false
	
	if (_count_ingredient(Ingredient.TYPE.ICE) > 3):
		return false
	
	return true
	
func _count_ingredient(type: Ingredient.TYPE) -> int:
	var count = 0
	
	for ingredient in ingredients:
		if(ingredient.type == type):
			count += 1 
	
	return count
