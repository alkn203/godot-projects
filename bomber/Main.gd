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

var DIR_ARRAY = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
onready var explosion_scene = preload("res://Explosion.tscn")
onready var explosion_layer = get_node("/root/Main/Stage1/ExplosionLayer")

func explode(bomb):
        var tile_pos = bomb.tilePos;
        var pos = bomb.position
        var power = bomb.power;
        #
        bomb.queue_free()
        #
        var explode_count = 1;
        # 中心の爆発
        var explosion = explosion_scene.instance()
        main.locate_object(explosion, tile_pos)
        explosion_layer.add_child(explosion)
        explosion.play("center")
        
        var rot = 0
        # 四方向ループ
        for dir in DIR_ARRAY:
                var dx = dir.x
                var dy = dir.y
                # 爆発のグラフィック回転方向セット
                        if dx == 1:
                                rot = 90
                        if dx == -1:
                                rot = 270
                        if dy == 1:
                                rot = 180
                        if dy == -1:
                                rot = 0
        #
        var next_pos = pos + dir
          // 爆発処理
          _explode_next(next_pos, dir, rot, power, explode_count);  


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
