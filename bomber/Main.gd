extends Node2D

# タイル番号
enum {NONE, WALL, BLOCK}
# 方向
const DIR_ARRAY = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
# 敵の位置
const ENEMY_ARRAY = [Vector2(5, 1), Vector2(8, 5), Vector2(5, 9), Vector2(2, 13)]
# シーン
const Explosion = preload("res://Explosion.tscn")
const Block = preload("res://Block.tscn")
const Enemy = preload("res://Enemy.tscn")
# ノード
onready var tilemap = get_node("/root/Main/TileMapLayer/TileMap")
onready var explosion_layer = get_node("/root/Main/ExplosionLayer")
onready var block_layer = get_node("/root/Main/BlockLayer")
onready var enemy_layer = get_node("/root/Main/EnemyLayer")

# 初期化処理
func _ready():
  # 敵を配置
  for pos in ENEMY_ARRAY:
    var enemy = Enemy.instance()
    enemy.position = tilemap.map_to_world(pos)
    enemy_layer.add_child(enemy)

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
    var block = Block.instance()
    block.tile_pos = tile_pos
    block.position = tilemap.map_to_world(tile_pos)
    block_layer.add_child(block)
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
func _set_explosion(tile_pos, type, rotation):
  var explosion = Explosion.instance()
  explosion.tile_pos = tile_pos
  # センター寄せのため位置調整
  explosion.position = tilemap.map_to_world(tile_pos) + Vector2(32, 32)
  explosion_layer.add_child(explosion)
  # アニメーション指定
  explosion.get_node("AnimatedSprite").play(type)
  # 回転角度設定
  explosion.rotation_degrees = rotation
