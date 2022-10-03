extends KinematicBody2D

const KEY_ARRAY = [
		["ui_down", Vector2(0, 1)],
		["ui_up", Vector2(0, -1)],
		["ui_left", Vector2(-1, 0)],
		["ui_right", Vector2(1, 0)]]
# プレイヤーの速度
export (int) var speed = 150
# 移動方向ベクトル
var velocity = Vector2(0, 0)
# やられたかのフラグ
var defeated = false
# シーン
const BombArea = preload("res://BombArea.tscn")
const Bomb = preload("res://Bomb.tscn")
# ノード
onready var tilemap = get_node("/root/Main/TileMapLayer/TileMap")
onready var bombarea_layer = get_node("/root/Main/BombAreaLayer")
onready var bomb_layer = get_node("/root/Main/BombLayer")
onready var animated_sprite = get_node("AnimatedSprite")

# やられ処理
func disable():
	# やられフラグセット
	defeated = true
	# コリジョンを無効化
	get_node("CollisionShape2D").set_deferred("disabled", true)
	# やられアニメーション
	animated_sprite.play("defeated")

# 初期化処理
func _ready():
	# 最初のアニメーション
	animated_sprite.play("ui_down_stop")

# 毎フレーム処理
func _physics_process(delta):
	# やられていたら何もしない
	if defeated:
		return
	# 移動入力受付
	_get_move_input()
	# 移動と当たり判定
	var collision = move_and_collide(velocity * delta)
	# 爆弾がなければ爆弾セット
	if bomb_layer.get_child_count() == 0:
		if Input.is_action_just_pressed("ui_z"):
			_set_bomb() 

# 移動検知
func _get_move_input():
	velocity = Vector2(0, 0)
	
	for elem in KEY_ARRAY:
		var dir = elem[0]
		# キーにより方向振り分け
		if Input.is_action_pressed(dir):
			animated_sprite.play(dir)
			velocity = elem[1]
			
	velocity = velocity.normalized() * speed

	for elem in KEY_ARRAY:
		var dir = elem[0]
		# キーが離された時
		if Input.is_action_just_released(dir):
			animated_sprite.play(dir + "_stop")
			
# 爆弾セット処理
func _set_bomb():
	# プレイヤーとの当たり判定をなしにする 
	set_collision_mask_bit(2, false)
	# ダミーの当たり判定
	var bombarea = BombArea.instance()
	bombarea.tile_pos = tilemap.world_to_map(position)
	bombarea.position = tilemap.map_to_world(bombarea.tile_pos)
	bombarea_layer.add_child(bombarea)
	# 爆弾
	var bomb = Bomb.instance()
	bomb.tile_pos = tilemap.world_to_map(position)
	bomb.position = tilemap.map_to_world(bomb.tile_pos)
	bomb_layer.add_child(bomb)
