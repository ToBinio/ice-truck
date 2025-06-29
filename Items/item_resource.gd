extends Resource
class_name ItemResource

@export var basic: BasicIngredient

@export var base: BaseIngredient
@export var addon: AddonIngredient
@export var ice: Array[IceIngredient]

const SCENE = preload("res://Items/Item.tscn")

static func from_ingredient(ingredient:Ingredient) -> ItemResource:
	var item = ItemResource.new()
	
	if ingredient is BasicIngredient:
		item.basic = ingredient
	if ingredient is AddonIngredient:
		item.addon = ingredient
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
	
	if(a.addon):
		item.addon = a.addon
	if(b.addon):
		item.addon = b.addon
	
	item.ice.append_array(a.ice)
	item.ice.append_array(b.ice)
	
	return item

static func can_combine(a: ItemResource, b: ItemResource) -> bool:
	if a.basic or b.basic:
		return false
	
	if a.base and b.base:
		return false
	
	if a.addon and b.addon:
		return false
	
	if a.ice.size() + b.ice.size() > 3:
		return false
	
	return true

func is_same(other: ItemResource) -> bool:
	if basic != other.basic:
		return false
	if base != other.base:
		return false
	if addon != other.addon:
		return false
	
	if ice.size() != other.ice.size():
		return false
		
	for value in ice:
		if not other.ice.has(value):
			return false
			
	return true
