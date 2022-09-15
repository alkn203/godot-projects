extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var DIR_ARRAY = [[Vector2(-1, 0), 270], [Vector2(1, 0), 90], [Vector2(0, -1), 0], [Vector2(0, 1), 180]]
onready var tilemap = get_node("/root/Main/TileMap")
onready var explosion_scene = preload("res://Explosion.tscn")
onready var explosion_layer = get_node("/root/Main/ExplosionLayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
        # 四方向ループ
        for item in DIR_ARRAY:
                # 次の方向
                var dir = item[0]
                # 爆発のグラフィック回転方向
                var rot = item[1]
                # 次の位置
                var next_pos = pos + dir
                # 爆発処理
                _explode_next(next_pos, dir, rot, power, explode_count);  

func explode_next(tile_pos, dir, rot, power, explode_count):
        # 指定した位置のタイルをチェック
        var tile = tilemap.checkTileByIndex(pos.x, pos.y);
        # 壁
        if tile == WALL:
               return
        # ブロック
        if tile == BLOCK:
               # 破壊エフェクト
               #obj.disable()
               return
        # 爆発の端
        if power == explode_count:
               var edge = explosion_scene.instance()
               main.locate_object(edge, tile_pos)
               explosion_layer.add_child(edge)
               edge.play("edge")
               return
        # カウントアップ
        explode_count += 1
        # 途中の爆発
        var middle = explosion_scene.instance()
        middle.position = position
        main.locate_object(middle, tile_pos)
        explosion_layer.add_child(middle)
        middle.play("middle")
        #
        var next_pos = pos + dir
        # 同方向に１マス進めて再帰呼び出し
        explode_next(next_pos, dir, rot, power, explode_count)

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
