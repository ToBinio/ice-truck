extends Interactable

@onready var item_holdable: ItemHoldable = %ItemHoldable

@export var item: ItemResource:
	set(value):
		item = value
		
		if(item_holdable):
			item_holdable.item = value

func _ready() -> void:
	item_holdable.item = item

func interact(player: Player):
	if not item and player.item:
		item = player.item
		player.item = null
	else: if item and not player.item:
		player.item = item
		item = null
	else: if item and player.item:
		if not ItemResource.can_combine(item, player.item):
			return
		
		var combination = ItemResource.combine(item, player.item)
		item = combination
		player.item = null

func can_interact(player: Player) -> bool:
	if not item and not player.item:
		return false
	
	if item and player.item:
		return ItemResource.can_combine(item, player.item);
	
	return true
