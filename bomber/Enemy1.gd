extends KinematicBody2D

# 敵の速度
export (int) var speed = 120
# 移動方向ベクトル
var direction = Vector2(-1, 0)
# ノード
onready var enemy_layer = get_node("/root/Main/EnemyLayer")

# 毎フレーム処理
func _physics_process(delta):
	var velocity = direction * speed
        # 移動と当たり判定
	var collision = move_and_collide(velocity * delta)
        #
        if collision:
                if collision.collider is TileMap:
                        direction = direction.bounce(collision.normal)
                

