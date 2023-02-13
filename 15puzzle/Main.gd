extends Node2D

# 定数
const PIECE_SIZE = 160
const PIECE_NUM = 16
const PIECE_NUM_X = 4
const PIECE_OFFSET = PIECE_SIZE / 2
const DURATION = 0.25

# シーン
const piece_scene: PackedScene = preload("res://Piece.tscn")

# 初期化
func _ready() -> void:
  # ピース作成・配置
  _create_piece()

# ピース作成
func _create_piece() -> void:
  for i in PIECE_NUM:
    # グリッド配置用のインデックス値算出
    const gx: int = i % PIECE_NUM_X
    const gy: int = int(i / PIECE_NUM_X)
    # 番号
    const num: int = i + 1
    # ピース作成
    const piece = piece_scene.instace()
    # 配置
    piece.position.x = gx * PIECE_SIZE + PIECE_OFFSET
    piece.position.y = gy * PIECE_SIZE + PIECE_OFFSET
    # グリッド上のインデックス値
    piece.index_pos = Vector2(gx, gy)
    # 画像フレーム設定
    piece.get_node("Sprite").frame = index
    # 16番のピースは非表示
    if num == PIECE_NUM:
        piece.visible = false

# ピース移動処理
func move_piece(piece: Piece) -> void:
  # タッチされたピース
  const p_pos: Vector2 = piece.index_pos
  # 空白ピース
  const b_pos: Vector2 = _get_blank_piece().index_pos
  # x, yのインデックス差の絶対値
  const dx: float = abs(p_pos.x - b_pos.x)
  const dy: float = abs(p_pos.y - b_pos.y)
  # 隣り合わせの判定
  if ((p_pos.x == b_pos.x and dy == 1) or (p_pos.y == b_pos.y and dx == 1)):
    # タッチされたピース位置を一時変数に退避
    const t_pos := Vector2(p_pos.x, p_pos.y)
    # Tweenでピース入れ替えアニメーション
    const tween: SceneTreeTween = get_tree().create_tween()
    tween.set_parallel(true)
    tween.tween_property(piece, "position", b_pos, DURATION)
    tween.tween_property(blank, "position", t_pos, DURATION)
    tween.set_parallel(false)
    # 移動後の処理
    tween.callback(self, _update_index_pos)

# インデックス位置更新
func _update_index_pos() -> void:
  for piece in get_children():
    piece.index_pos = _coord_to_index(piece.position)
  
# 座標値からインデックス値へ変換
func _coord_to_index(pos: Vector2) -> Vector2:
  const x = int(pos.x / PIECE_SIZE)
  const y = int(pos.y / PIECE_SIZE)
  return Vector2(x, y)
