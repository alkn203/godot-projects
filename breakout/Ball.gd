class_name Ball
extends KinematicBody2D

# 定数
const SPEED = 300

# 変数
var velocity: = Vector2.DOWN * SPEED 

# 毎フレーム処理
func _physics_process(delta: float) -> void:
    # 移動と当たり判定
    var collision: KinematicCollision2D = move_and_collide(velocity * delta)
    # ヒットあり
    if collision:
        # 反転
        velocity = velocity.bounce(collision.normal)
        # 衝突した相手
        var target = collision.collider
        # パドルの場合
        if target is Paddle:
            # ヒットした位置に応じて角度をつける
            var dx: float = position.x - target.position.x
            velocity.x = dx * 2
        # ブロックの場合
        if target is Block:
            # 削除
            target.queue_free()
    
    # 移動量決定
    velocity = velocity.normalized() * SPEED 
