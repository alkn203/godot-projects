extends KinematicBody2D

# 定数
const GRAVITY = 9.8 / 2 
const JUMP_POWER = 304
const speed = 150

# 変数
var velocity = Vector2.ZERO

# ノード
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")

# 初期化処理
func _ready() -> void:
  # 最初のアニメーション
  animated_sprite.play("walk_right")
  
# 毎フレーム処理
func _physics_process(delta) -> void:
  # 移動と当たり判定
  velocity = move_and_slide(velocity, Vector2.UP)
  
  # 床の上なら
  if is_on_floor():
    # 左クリックでジャンプ
    if Input.is_action_just_pressed("ui_jump"):
      velocity.y = -JUMP_POWER

  # 重力を加算
  velocity.y += GRAVITY
