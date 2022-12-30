extends Node2D

# 定数
const PIECE_SIZE = 160
const DURATION = 0.25

# 変数
var blank: Piece

# 初期化
func _ready() -> void:
  # 空白ピース
  blank = get_node("Piece16")
  for piece in get_children():
    # インデックス値をスプライトのフレームにする
    var index: int = piece.get_index()
    piece.get_node("Sprite").frame = index

# ピース移動処理
func move_piece(piece: Piece) -> void:
  var p_pos: Vector2 = piece.position
  var b_pos: Vector2 = blank.position
  # x, yの座標差の絶対値
  var dx: float = abs(p_pos.x - b_pos.x);
  var dy: float = abs(p_pos.y - b_pos.y);
  # 隣り合わせの判定
  if ((p_pos.x == b_pos.x and dy == PIECE_SIZE) or (p_pos.y == b_pos.y and dx == PIECE_SIZE)):
    # タッチされたピース位置を一時変数に退避
    var t_pos := Vector2(p_pos.x, p_pos.y)
    # Tweenでピース入れ替えアニメーション
    var tween: SceneTreeTween = get_tree().create_tween()
    tween.set_parallel(true)
    tween.tween_property(piece, "position", b_pos, DURATION)
    tween.tween_property(blank, "position", t_pos, DURATION)
