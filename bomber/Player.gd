extends KinematicBody2D

# プレイヤーの速度
export (int) var speed = 150
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
	# 爆弾がなければ爆弾セット
        if bomb_layer.get_child_count() == 0:
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
		
	velocity = velocity.normalized() * speed

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
