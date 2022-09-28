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
	if direction.x == -1:
		sprite.frame = 0
	elif direction.x == 1:
		sprite.frame = 1
	elif direction.x == 0:
		sprite.frame = 2

	var velocity = direction * speed
	# 移動と当たり判定
	var collision = move_and_collide(velocity * delta)
	# ヒットあり
	if collision:
		var collider = collision.collider
		# タイルマップか爆弾なら反転移動
		if (collider is TileMap) or (collider.name == "Bomb"):
			direction = direction.bounce(collision.normal)

# やられ処理
func disable():
	# コリジョンを無効化
	get_node("CollisionShape2D").set_deferred("disabled", true)
	# 移動を停止
	direction = Vector2(0, 0)
	# 一定時間後に削除
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()

