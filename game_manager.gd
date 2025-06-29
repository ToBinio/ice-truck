extends Node
class_name GameManager

@onready var happiness_bar: ProgressBar = %HappinessBar
var happiness: float = 100.0
@export var happniness_gradient: Gradient

var survived_time: float = 0
@onready var timer: Label = %Timer

@onready var break_timer: Timer = %BreakTimer
@onready var break_sound_player: AudioStreamPlayer = %BreakSoundPlayer

@onready var music: AudioStreamPlayer = $Music

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var has_lost = false

var difficultly_scale = 3;

static func instance(node: Node) -> GameManager:
	return node.get_tree().get_first_node_in_group("GameManager")

func _ready() -> void:
	happiness_bar.value = happiness
	break_timer.start(randf_range(5,20))

func _process(delta: float) -> void:
	if has_lost:
		return

	difficultly_scale = 1 / (log((survived_time / 25) + 2) / log(10))

	if happiness <= 0:
		animation_player.play("Death")
		has_lost = true
		music.stop()
	
	survived_time += delta
	
	var minutes = int(survived_time) / 60
	var secs = fmod(survived_time, 60.0)
	timer.text = "%02d:%02d" % [minutes, secs]
	
	var service_tables = get_tree().get_nodes_in_group("Service") as Array[Service]
	
	for service in service_tables:
		if service.task:
			happiness -= delta
	
	happiness = clamp(happiness, 0, 120)
	
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
		break_sound_player.play()
		
	break_timer.start(randf_range(5 * difficultly_scale, 20 * difficultly_scale))


func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
