extends Node
class_name GameManager

@onready var happiness_bar: ProgressBar = %HappinessBar
var happiness: float = 100.0
@export var happniness_gradient: Gradient

var survived_time: float = 0
@onready var timer: Label = %Timer

@onready var break_timer: Timer = %BreakTimer

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var has_lost = false

static func instance(node: Node) -> GameManager:
	return node.get_tree().get_first_node_in_group("GameManager")

func _ready() -> void:
	happiness_bar.value = happiness
	break_timer.start(randf_range(5,20))

func _process(delta: float) -> void:
	if has_lost:
		return

	if happiness <= 0:
		animation_player.play("Death")
		has_lost = true
	
	survived_time += delta
	
	var minutes = int(survived_time) / 60
	var secs = fmod(survived_time, 60.0)
	timer.text = "%02d:%02d" % [minutes, secs]
	
	var service_tables = get_tree().get_nodes_in_group("Service") as Array[Service]
	
	for service in service_tables:
		if service.task:
			happiness -= delta
	
	happiness_bar.value = happiness
	happiness_bar.get("theme_override_styles/background").set("bg_color", happniness_gradient.sample(happiness / 100.))

func _on_timer_timeout() -> void:
	if has_lost:
		return
	
	var interactables = get_tree().get_nodes_in_group("Interactables")
	
	var break_able: Array[Interactable] = []
	
	for interactable in interactables:
		if interactable is Interactable:
			if interactable.can_break and not interactable.is_broken:
				break_able.append(interactable)
	
	if not break_able.is_empty():
		var interactable = break_able.pick_random() as Interactable
		interactable.is_broken = true
		
	break_timer.start(randf_range(5,20))


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
