extends KinematicBody2D

# プレイヤーの速度
export (int) var speed = 150
# 移動方向ベクトル
var velocity = Vector2(0, 0)

# ノード
onready var animated_sprite = get_node("AnimatedSprite")

# 初期化処理
func _ready():
  # 最初のアニメーション
  animated_sprite.play("ui_down_stop")

# 毎フレーム処理
func _physics_process(delta):
  # 移動と当たり判定
  var collision = move_and_collide(velocity * delta)

  if Input.is_action_just_pressed(dir):
    velocity = velocity
