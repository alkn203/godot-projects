extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tilemap = get_node("/root/Main/TileMap")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func locate_object(obj, pos):
        obj.tile_pos = pos
        obj.position = map_to_global(pos)

func global_to_map(pos):
	var local_pos = tilemap.to_local(pos)
	var map_pos = tilemap.world_to_map(local_pos)
	return map_pos

func map_to_global(pos):
	var local_pos = tilemap.map_to_world(pos)
	var global_pos = tilemap.to_global(local_pos)
	return global_pos
