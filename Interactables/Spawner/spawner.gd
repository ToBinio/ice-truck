extends Interactable

@export var item: ItemResource

func interact(player: Player):
	if not player.item:
		player.item = item
