extends Node2D


# Declare member variables here. Examples:
enum {NONE, WALL, BLOCK}

var DIR_ARRAY = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]

onready var explosion_scene = preload("res://Explosion.tscn")
onready var stage = get_node("/root/Main/Stage")
onready var explosion_layer = get_node("/root/Main/ExplosionLayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# 爆発処理
func explode(bomb):
	var tile_pos = bomb.tile_pos
	var power = bomb.power
	# 爆弾は削除
	bomb.queue_free()
	# 爆発の広がりカウント用
	var explode_count = 1;
	# 中心の爆発
	var explosion = explosion_scene.instance()
	explosion.tile_pos = tile_pos
	explosion.position = map_to_global(tile_pos) + Vector2(32, 32)
	explosion_layer.add_child(explosion)
	# 中心のアニメーション
	explosion.get_node("AnimatedSprite").play("center")
	# 四方向ループ
	for dir in DIR_ARRAY:
		var dx = dir.x
		var dy = dir.y
		var rot = 0
		# 次の方向
		if dx == 1:
			# 爆発のグラフィック回転方向
			rot = 90
		if dx == -1:
			rot = 270
		if dy == 1:
			rot = 180
		if dy == -1:
			rot = 0
		# 次の位置
		var next_pos = tile_pos + dir
		# 爆発拡大処理
		_explode_next(next_pos, dir, rot, power, explode_count);  

# 周りの爆発処理
func _explode_next(tile_pos, dir, rot, power, explode_count):
	# 指定した位置のタイルをチェック
	var tile = stage.get_cellv(tile_pos)
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
		edge.tile_pos = tile_pos
		edge.position = map_to_global(tile_pos) + Vector2(32, 32)
		explosion_layer.add_child(edge)
		# 端のアニメーション
		edge.get_node("AnimatedSprite").play("edge")
		# 角度セット
		edge.rotation_degrees = rot
		return
	# カウントアップ
	explode_count += 1
	# 途中の爆発
	var middle = explosion_scene.instance()
	middle.tile_pos = tile_pos
	middle.position = map_to_global(tile_pos) + Vector2(32, 32)
	explosion_layer.add_child(middle)
	middle.get_node("AnimatedSprite").play("middle")
	middle.rotation_degrees = rot
	# 次の位置
	var next_pos = tile_pos + dir
	# 同方向に１マス進めて再帰呼び出し
	_explode_next(next_pos, dir, rot, power, explode_count)

func locate_object(obj, pos):
	obj.tile_pos = pos
	obj.position = map_to_global(pos)

func global_to_map(pos):
	var local_pos = stage.to_local(pos)
	var map_pos = stage.world_to_map(local_pos)
	return map_pos

func map_to_global(pos):
	var local_pos = stage.map_to_world(pos)
	var global_pos = stage.to_global(local_pos)
	return global_pos
