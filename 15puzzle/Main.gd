extends Node2D


# 定数
const PIECE_SIZE = 160

# ノード
onready var blank = get_node("Piece16")

# 初期化
func _ready():
  for piece in get_children():
    # インデックス値をスプライトのフレームにする
    var index = piece.get_index()
    piece.get_node("Sprite").frame = index

# ピース移動処理
func move_piece(piece):
  var p_pos = piece.position
  var b_pos = blank.position
  # x, yの座標差の絶対値
  var dx = abs(p_pos.x - b_pos.x);
  var dy = abs(p_pos.y - b_pos.y);
  # 隣り合わせの判定
    if ((p_pos.x == b_pos.x and dy == PIECE_SIZE) or (p_pos.y == b_pos.y and dx == PIECE_SIZE)):
      # タッチされたピース位置を一時変数に退避
      var t_pos = Vector2(p_pos.x, p_pos.y)
      # ピース入れ替えアニメーション
      var tween = get_tree().create_tween()
      tween.set_parallel(true)
      tween.tween_property(piece, "position", b_pos, DURATION)
      tween.tween_property(blank, "position", t_pos, DURATION)
      tween.set_parallel(false)
      tween.tween_callback(self, "_after_swap")
    
      piece.position = b_pos
      blank.position = t_pos
