extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var TILE_SIZE = 64


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func locate_object(obj, pos):
        obj.tile_pos = pos
        obj.position.x = pos.x * TILE_SIZE
        obj.position.y = pos.y * TILE_SIZE
