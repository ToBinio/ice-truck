extends CharacterBody2D
class_name Player


@export var speed = 300.0
@export var acceleration = 20

@onready var ray_cast: RayCast2D = %RayCast2D
@onready var item_holdable: ItemHoldable = %ItemHoldable

@onready var animation_tree: AnimationTree = %AnimationTree

var _target_direction: Vector2;
var _facing_direction: Vector2 = Vector2.RIGHT;

@export var item: ItemResource:
	set(value):
		item = value
		
		if(item_holdable):
			item_holdable.item = value

func _ready() -> void:
	item_holdable.item = item

func _process(_delta: float) -> void:
	animation_tree.set("parameters/blend_position", velocity)
	
	var ray_length = ray_cast.target_position.length()
	ray_cast.target_position = _facing_direction * ray_length
	
	var item_distance = item_holdable.position.length()
	item_holdable.position = _facing_direction * item_distance
	
	var collider = ray_cast.get_collider()
		
	if collider and collider is Interactable:
		collider.try_interact(self)

func _input(event: InputEvent) -> void:
	if GameManager.instance(self).has_lost:
		return
		
	if event.is_action_pressed("interact"):
		var collider = ray_cast.get_collider()
		
		if collider and collider is Interactable:
			if collider.can_interact(self):
				collider.interact(self)

func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	if input and not GameManager.instance(self).has_lost:
		_facing_direction = input
		_target_direction = input * speed
	else:
		_target_direction = Vector2.ZERO
	
	velocity = lerp(velocity,_target_direction, _delta * acceleration) 
	
	move_and_slide()
