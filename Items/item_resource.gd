extends Resource
class_name ItemResource

@export var basic: BasicIngredient

@export var base: BaseIngredient
@export var ice: Array[IceIngredient]

const SCENE = preload("res://Items/Item.tscn")

static func from_ingredient(ingredient:Ingredient) -> ItemResource:
	var item = ItemResource.new()
	
	if ingredient is BasicIngredient:
		item.basic = ingredient
	if ingredient is IceIngredient:
		item.ice.append(ingredient)
	if ingredient is BaseIngredient:
		item.base = ingredient
	
	return item

static func combine(a: ItemResource, b: ItemResource) -> ItemResource:
	var item = ItemResource.new()
	
	if(a.base):
		item.base = a.base
	if(b.base):
		item.base = b.base
	
	item.ice.append_array(a.ice)
	item.ice.append_array(b.ice)
	
	return item

static func can_combine(a: ItemResource, b: ItemResource) -> bool:
	if a.basic or b.basic:
		return false
	
	if a.base and b.base:
		return false
	
	if a.ice.size() + b.ice.size() > 3:
		return false
	
	return true
