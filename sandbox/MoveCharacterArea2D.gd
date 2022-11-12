extends Sprite

# 定数
const PLAYER_SPEED = 5
const KEY_ARRAY = [
    ["ui_down", Vector2(0, 1)],
    ["ui_up", Vector2(0, -1)],
    ["ui_left", Vector2(-1, 0)],
    ["ui_right", Vector2(1, 0)]]

# 毎フレーム処理
func _process(delta):
  var velocity = Vector2.ZERO
  
  for elem in KEY_ARRAY:
    var dir = elem[0]
    # キーにより方向振り分け
    if Input.is_action_pressed(dir):
      velocity = elem[1]
  # 何かしら入力があれば
  if velocity.x != 0 or velocity.y != 0:
    # プレイヤー位置更新
    position += velocity * PLAYER_SPEED
