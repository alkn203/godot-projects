extends KinematicBody2D

# 敵の速度
export (int) var speed = 50
# 移動方向ベクトル
var direction = Vector2(-1, 0)
# ノード
onready var sprite = get_node("Sprite")
onready var enemy_layer = get_node("/root/Main/EnemyLayer")

# 毎フレーム処理
func _physics_process(delta):
	# 移動方向でフレームを変更
	if direction.x < 0:
		sprite.frame = 0
	else:
		sprite.frame = 1

	var velocity = direction * speed
	# 移動と当たり判定
	var collision = move_and_collide(velocity * delta)
	# ヒットあり
	if collision:
		# タイルマップか爆弾なら反転移動
		if collision.collider is TileMap:
			direction = direction.bounce(collision.normal)
		if collision.collider.name == "Bomb":
			direction = direction.bounce(collision.normal)
				

