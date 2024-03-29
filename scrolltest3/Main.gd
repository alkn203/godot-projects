extends Node2D

# 定数
const DURATION = 2.0

# 変数
var screen_size: Vector2
var prev_velocity: Vector2
var prev_gravity: float
var is_scrolling: bool

# ノード
onready var player: Player = get_node("Player")
onready var camera: Camera2D = get_node("Camera2D")

# 初期化処理
func _ready():
  # 画面サイズ
  screen_size = get_viewport_rect().size
  # スクロール中かどうか
  is_scrolling = false

# 毎フレーム処理
func _process(delta):
  var dir = 0
  # カメラの両端到達判定
  if player.position.x > camera.position.x + screen_size.x / 2:
    dir = 1
  if player.position.x <  camera.position.x - screen_size.x / 2:
    dir = -1
  
  # 到達したら動きを止める  
  if dir != 0 and !is_scrolling:
    prev_velocity = player.velocity
    prev_gravity = player.gravity
    player.velocity = Vector2.ZERO
    player.gravity = 0
    # スクロール処理
    _zelda_scroll(dir)

# 
func _zelda_scroll(dir):
  is_scrolling = true
  # カメラの移動先 
  var dest: Vector2 = camera.position + Vector2(dir * screen_size.x, 0)
  # 
  var tween = get_tree().create_tween()
  tween.tween_property(camera, "position", dest, DURATION)
  tween.tween_callback(self, "_after_scroll")

func _after_scroll():
  player.velocity = prev_velocity
  player.gravity = prev_gravity 
  is_scrolling = false
