extends Node
class_name GameManager

@onready var happiness_bar: ProgressBar = %HappinessBar
var happiness: float = 100.0

static func instance(node: Node) -> GameManager:
	return node.get_tree().get_first_node_in_group("GameManager")

func _ready() -> void:
	happiness_bar.value = happiness

func _process(delta: float) -> void:
	var service_tables = get_tree().get_nodes_in_group("Service") as Array[Service]
	
	for service in service_tables:
		if service.task:
			happiness -= delta
	
	happiness_bar.value = happiness

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
