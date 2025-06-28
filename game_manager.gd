extends Node

func _on_timer_timeout() -> void:
	var interactables = get_tree().get_nodes_in_group("Interactables")
	
	var break_able: Array[Interactable] = []
	
	for interactable in interactables:
		if interactable is Interactable:
			if interactable.can_break and not interactable.is_broken:
				break_able.append(interactable)
	
	if not break_able.is_empty():
		var interactable = break_able.pick_random() as Interactable
		interactable.is_broken = true
