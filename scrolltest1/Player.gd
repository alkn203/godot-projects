extends KinematicBody2D
class_name Player

# 定数
const GRAVITY = 9.8 / 2 
const JUMP_POWER = 210
const speed = 180

# 変数
var velocity: Vector2 = Vector2.ZERO

# ノード
onready var anim: AnimatedSprite = get_node("AnimatedSprite")

# 初期化処理
func _ready():
  # 最初のアニメーション
  anim.play("walk_right")
  # 少し待ってから移動（ワープっぽい動き対策）
  yield(get_tree().create_timer(0.3), "timeout")
  # 右に移動
  velocity = Vector2(speed, 0)
  
# 毎フレーム処理
func _physics_process(delta):
  # プレイヤーの向き判定
  if velocity.x < 0:
    anim.play("walk_left")
  if velocity.x > 0:
    anim.play("walk_right")

  # 衝突前のベクトルを退避
  var prev_velocity: Vector2 = velocity
  # 移動と当たり判定
  velocity = move_and_slide(velocity, Vector2.UP)
  # 床の上なら
  if is_on_floor():
    # 左クリックでジャンプ
    if Input.is_action_just_pressed("ui_jump"):
      velocity.y = -JUMP_POWER

  # 壁に接触なら
  if is_on_wall():
    # 衝突情報から反射ベクトルを算出
    if get_slide_count() > 0:
      var collision: KinematicCollision2D = get_slide_collision(0)
      velocity = prev_velocity.bounce(collision.normal)
      
  # 重力を加算
  velocity.y += GRAVITY
