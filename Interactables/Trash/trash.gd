extends Interactable

func interact(player: Player):
	if super(player):
		return
	
	player.item = null

func can_interact(player: Player):
	if super(player) != null:
		return super(player)
	
	return player.item != null;
