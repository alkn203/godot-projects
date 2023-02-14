extends Node2D

# 定数
const PIECE_SIZE = 160
const PIECE_NUM = 16
const PIECE_NUM_X = 4
const PIECE_OFFSET = PIECE_SIZE / 2
const DURATION = 0.25

# シーン
const Piece: PackedScene = preload("res://Piece.tscn")

# 変数
var blank_piece: Piece

# 初期化
func _ready() -> void:
  # ピース作成・配置
  _create_piece()

# ピース移動処理
func move_piece(piece: Piece) -> void:
  var p1: Vector2 = piece.index_pos
  var p2: Vector2 = blank_piece.index_pos
  # x, yのインデックス差の絶対値
  var dx: float = abs(p1.x - p2.x)
  var dy: float = abs(p1.y - p2.y)
  # 隣り合わせの判定
  if ((p1.x == p2.x and dy == 1) or (p1.y == p2.y and dx == 1)):
    # タッチされたピース位置を一時変数に退避
    var t_pos := Vector2(piece.position.x, piece.position.y)
    # Tweenでピース入れ替えアニメーション
    var tween: SceneTreeTween = get_tree().create_tween()
    tween.set_parallel(true)
    tween.tween_property(piece, "position", blank_piece.position, DURATION)
    tween.tween_property(blank_piece, "position", t_pos, DURATION)
    tween.set_parallel(false)
    tween.tween_callback(self, "_update_index_pos")

# ピース作成・配置
func _create_piece() -> void:
  for i in PIECE_NUM:
    # グリッド配置用のインデックス値算出
    var gx: int = i % PIECE_NUM_X
    var gy: int = int(i / PIECE_NUM_X)
    # 番号
    var num: int = i + 1
    # ピース作成
    var piece = Piece.instance()
    add_child(piece)
    # 配置
    piece.position.x = gx * PIECE_SIZE + PIECE_OFFSET
    piece.position.y = gy * PIECE_SIZE + PIECE_OFFSET
    # グリッド上のインデックス値
    piece.index_pos = Vector2(gx, gy)
    # 画像フレーム設定
    piece.get_node("Sprite").frame = i
    # 16番のピースは非表示
    if num == PIECE_NUM:
      blank_piece = piece
      piece.visible = false

# インデックス位置更新
func _update_index_pos() -> void:
  for piece in get_children():
    piece.index_pos = _coord_to_index(piece.position)

# 座標値からインデックス値へ変換
func _coord_to_index(pos: Vector2) -> Vector2:
  var x = int(pos.x / PIECE_SIZE)
  var y = int(pos.y / PIECE_SIZE)
  return Vector2(x, y)
