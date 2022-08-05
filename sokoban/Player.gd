extends Sprite


# Declare member variables here. Examples:
const TILE_SIZE = 64
var grid_pos = Vector2(4, 8)
onready var tilemap = get_node("/root/Main/Stage1/TileMap")
onready var baggage_layer = get_node("/root/Main/Stage1/BaggageLayer")


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	var v = Vector2(0, 0)
	#
	if Input.is_action_just_pressed("ui_left"):
		v.x = -1
	if Input.is_action_just_pressed("ui_right"):
		v.x = 1
	if Input.is_action_just_pressed("ui_up"):
		v.y = -1
	if Input.is_action_just_pressed("ui_down"):
		v.y = 1
	#
	if v.x != 0 or v.y != 0:
		var next = grid_pos + v
		#print(tilemap.get_cellv(next))
		if tilemap.get_cellv(next) == 3: # 壁
			return
		
		for baggage in baggage_layer.get_children():
			#
			if baggage.tile_pos == next:
				if tilemap.get_cellv(next + v) == 3:
					return
		# プレイヤー位置更新
		grid_pos = next
		position += v * TILE_SIZE
