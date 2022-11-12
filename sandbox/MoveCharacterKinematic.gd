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

# 毎フレーム処理
func _physics_process(delta):
  # 移動入力受付
  velocity = Vector2(0, 0)
  
  for elem in KEY_ARRAY:
    var dir = elem[0]
    # キーにより方向振り分け
    if Input.is_action_pressed(dir):
      velocity = elem[1]
      
  velocity = velocity.normalized() * speed
  # 移動と当たり判定
  var collision = move_and_collide(velocity * delta)
