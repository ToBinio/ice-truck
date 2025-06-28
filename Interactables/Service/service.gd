extends Interactable
class_name Service

@export var possible_ice: Array[IceIngredient]
@export var possible_base: Array[BaseIngredient]

@onready var item_display: ItemHoldable = %ItemDisplay
@onready var task_node: Node2D = %Task

var _show_task: bool = false
var task: ItemResource

func _process(delta: float) -> void:
	super(delta)
	
	if _show_task:
		task_node.show()
	else:
		task_node.hide()
	
	_show_task = false

func interact(player: Player):
	if super(player):
		return
		
	if(task.is_same(player.item)):
		task = null
		_display_task()
		GameManager.instance(self).happiness += 20
		print("Served correcly")
	else:
		GameManager.instance(self).happiness -= 25
		print("nope")
		
	player.item = null

func try_interact(player: Player):
	super(player)
	_show_task = true

func can_interact(player: Player):
	if super(player) != null:
		return super(player)
	
	return player.item and player.item.basic == null;

var i = 0;
func _display_task():
	item_display.item = task
	
	for child in task_node.get_children():
		child.free()
	
	if not task:
		return
	
	i = 0
	
	var add_icon = func(ingredient:Ingredient):
		var sprite = Sprite2D.new()
		sprite.texture = ingredient.icon_texture
		sprite.position.y = i / 2 * 10
		sprite.position.x = -5 if i % 2 == 0 else 5 
		
		task_node.add_child(sprite)
		
		i += 1
	
	add_icon.call(task.base);
	
	for ice in task.ice:
		add_icon.call(ice);

func _on_timer_timeout() -> void:
	if not task:
		var item = ItemResource.new()
		
		item.base = possible_base.pick_random()
		
		for i in randi_range(1,3):
			item.ice.append(possible_ice.pick_random())
		
		task = item
		_display_task()
