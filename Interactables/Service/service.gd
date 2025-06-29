extends Interactable
class_name Service

@export var possible_ice: Array[IceIngredient]
@export var possible_base: Array[BaseIngredient]

@onready var item_container: Node2D = %ItemContainer
@onready var item_display: ItemHoldable = %ItemDisplay

@onready var task_node: Node2D = %Task

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var customer_stream_player: AudioStreamPlayer = %CustomerStreamPlayer

@onready var timer: Timer = %Timer
@onready var money_audio_stream: AudioStreamPlayer = %MoneyAudioStream

var _show_task: bool = false
var task: ItemResource

func _ready() -> void:
	timer.start(randf_range(2,15))
	item_container.hide()

func _process(delta: float) -> void:
	super(delta)
	
	if _show_task and task:
		task_node.show()
	else:
		task_node.hide()
	
	_show_task = false

func interact(player: Player):
	if super(player):
		return

	if (task.is_same(player.item)):
		task = null
		_display_task()
		GameManager.instance(self).happiness += 20
		animation_player.play("Down")
		money_audio_stream.play()
		
		print("Served correcly")
			
	player.item = null

func try_interact(player: Player):
	super(player)
	_show_task = true

func can_interact(player: Player):
	if super(player) != null:
		return super(player)
	
	return player.item and player.item.basic == null and task and task.is_same(player.item);

var i = 0;
func _display_task():
	item_container.visible = task != null
	item_display.item = task
	
	for child in task_node.get_children():
		child.free()
	
	if not task:
		return
	
	i = 0
	
	var add_icon = func(ingredient:Ingredient):
		var sprite = Sprite2D.new()
		sprite.texture = ingredient.icon_texture
		
		@warning_ignore("integer_division")
		sprite.position.y = i / 2 * 10
		sprite.position.x = -5 if i % 2 == 0 else 5 
		
		task_node.add_child(sprite)
		
		i += 1
	
	add_icon.call(task.base);
	
	for ice in task.ice:
		add_icon.call(ice);

func _on_timer_timeout() -> void:
	var services = get_tree().get_nodes_in_group("Service") as Array[Service]
	var open_tasks = 0 
	
	for service in services:
		if service.task:
			open_tasks += 1
	
	if randf() <= open_tasks * 0.2:
		timer.start(randf_range(5,10))
		return
	
	if not task:
		var item = ItemResource.new()
		
		item.base = possible_base.pick_random()
		
		for _i in randi_range(1,3):
			item.ice.append(possible_ice.pick_random())
		
		animation_player.play("To")
		task = item
		
		await get_tree().create_timer(1.5).timeout
		
		_display_task()
		customer_stream_player.play()
	
	var game_mamanger = GameManager.instance(self)
	timer.start(randf_range(5 * game_mamanger.difficultly_scale,10 * game_mamanger.difficultly_scale))
