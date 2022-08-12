extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func global_to_map(pos):
	var local_pos = to_local(pos)
	var map_pos = world_to_map(local_pos)
	return map_pos

func map_to_global(pos):
	var local_pos = map_to_world(pos)
	var global_pos = to_global(local_pos)
	return global_pos
