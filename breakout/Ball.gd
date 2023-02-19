class_name Ball
extends KinematicBody2D

# 定数
const SPEED = 200

# 変数
var velocity: = Vector2.DOWN * SPEED 

# 毎フレーム処理
func _physics_process(delta) -> void:
    # 移動と当たり判定
    var collision: KinematicCollision2D = move_and_collide(velocity * delta)
    # ヒットあり
    if collision:
        # 反転
        velocity = velocity.bounce(collision.normal)
        # パドルの場合
        if collision.collider.name == "Paddle":
            var dx: float = position.x - collision.collider.position.x
            velocity.x = dx * 2
    
    # 移動先決定
    velocity = velocity.normalized() * SPEED 
