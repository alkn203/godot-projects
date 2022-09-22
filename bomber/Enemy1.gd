extends KinematicBody2D

# プレイヤーの速度
export (int) var speed = 120
# 移動方向ベクトル
var velocity = Vector2(0, 0)
# シーン
const BombArea = preload("res://BombArea.tscn")
const Bomb = preload("res://Bomb.tscn")
# ノード
onready var tilemap = get_node("/root/Main/TileMapLayer/TileMap")
onready var bombarea_layer = get_node("/root/Main/BombAreaLayer")
onready var bomb_layer = get_node("/root/Main/BombLayer")

# 毎フレーム処理
func _physics_process(delta):
	_get_move_input()
		# 移動と当たり判定
	var collision = move_and_collide(velocity * delta)
	# Confirm the colliding body is a TileMap
	if collision:
		if collision.collider is TileMap:
			# Find the character's position in tile coordinates
			var tile_pos = collision.collider.world_to_map(position)
			# Find the colliding tile position
			tile_pos -= collision.normal
			# Get the tile id
			var tile_id = collision.collider.get_cellv(tile_pos)
				
	# 爆弾セット
	if Input.is_action_just_pressed("ui_z"):
		_set_bomb() 

# 移動検知
func _get_move_input():
	velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	velocity = velocity.normalized() * sp
