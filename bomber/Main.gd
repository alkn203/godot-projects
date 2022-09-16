extends Node2D


# 方向
var DIR_ARRAY = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]

onready var explosion_scene = preload("res://Explosion.tscn")
onready var tilemap = get_node("/root/Main/TileMap")
onready var explosion_layer = get_node("/root/Main/ExplosionLayer")
# タイル番号
enum { NONE, WALL, BLOCK }

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
	_set_explosion(tile_pos, "center", 0)
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
	var tile = tilemap.get_cellv(tile_pos)
	# 壁
	if tile == WALL:
		return
	# ブロック
	if tile == BLOCK:
		# タイルを床に置き換える
		tilemap.set_cellv(tile_pos, NONE)
		# ブロック破壊エフェクト
		#obj.disable()
		return
	# 爆発の端
	if power == explode_count:
		_set_explosion(tile_pos, "edge", rot)
		return
	# カウントアップ
	explode_count += 1
	# 途中の爆発
	_set_explosion(tile_pos, "middle", rot)
	# 次の位置
	var next_pos = tile_pos + dir
	# 同方向に１マス進めて再帰呼び出し
	_explode_next(next_pos, dir, rot, power, explode_count)

# 爆発を配置
func _set_explosion(tile_position, type, rotation):
	var explosion = explosion_scene.instance()
	explosion.tile_pos = tile_position
	# センター寄せのため位置調整
	explosion.position = map_to_global(tile_position) + Vector2(32, 32)
	explosion_layer.add_child(explosion)
	# アニメーション指定
	explosion.get_node("AnimatedSprite").play(type)
	# 回転角度設定
	explosion.rotation_degrees = rotation

#
func locate_object(obj, pos):
	obj.tile_pos = pos
	obj.position = map_to_global(pos)

# 絶対座標からタイルマップ位置に変換
func global_to_map(pos):
	var local_pos = tilemap.to_local(pos)
	var map_pos = tilemap.world_to_map(local_pos)
	return map_pos

# タイルマップ位置から絶対座標に変換
func map_to_global(pos):
	var local_pos = tilemap.map_to_world(pos)
	var global_pos = tilemap.to_global(local_pos)
	return global_pos