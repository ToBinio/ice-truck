extends CharacterBody2D
class_name Player


@export var speed = 300.0
@export var acceleration = 20

@onready var rotated: Node2D = %Rotated
@onready var ray_cast: RayCast2D = %RayCast2D

@onready var item_holdable: ItemHoldable = %ItemHoldable

var _target_direction: Vector2;
var _facing_direction: Vector2;

@export var item: ItemResource:
	set(value):
		item = value
		
		if(item_holdable):
			item_holdable.item = value

func _ready() -> void:
	item_holdable.item = item

func _process(delta: float) -> void:
	rotated.rotation = _facing_direction.angle()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var collider = ray_cast.get_collider()
		
		if collider and collider is Interactable:
			collider.interact(self)
			

func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("left", "right", "up", "down")
	if input:
		_facing_direction = input
		_target_direction = input * speed
	else:
		_target_direction = Vector2.ZERO
	
	velocity = lerp(velocity,_target_direction, _delta * acceleration) 
	
	move_and_slide()
