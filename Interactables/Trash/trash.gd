extends Interactable

func interact(player: Player):
	player.item = null

func can_interact(player: Player) -> bool:
	return player.item != null;
