extends Node2D
class_name ItemHoldable

@export var item: ItemResource:
	set(value):
		item = value
		
		if _item_node:
			_item_node.free()
		
		if item:
			var scene = item.SCENE.instantiate() as Item
			scene.resource = item
			
			_item_node = scene
			add_child(scene)
			
var _item_node: Node
