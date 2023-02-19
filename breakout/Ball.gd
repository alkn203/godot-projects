class_name Ball
extends KinematicBody2D

# 変数
var velocity = Vector2(0, 200)

# 毎フレーム処理
func _physics_process(delta):
    # 移動と当たり判定
    var collision = move_and_collide(velocity * delta)
    # ヒットあり
    if collision:
        # 反転
        velocity = velocity.bounce(collision.normal)
