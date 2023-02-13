extends Node2D

# 定数
const PIECE_SIZE = 160
const PIECE_NUM = 16
const PIECE_NUM_X = 4
const PIECE_OFFSET = PIECE_SIZE / 2
const DURATION = 0.25

# シーン
const piece_scene: PackedScene = preload()

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
    piece.position.x = gx * PIECE_SIXE + PIECE_OFFSET
    piece.position.y = gy * PIECE_SIXE + PIECE_OFFSET
    # グリッド上のインデックス値
    piece.index_pos = Vector2(gx, gy)
    # 画像フレーム設定
    piece.get_node("Sprite").frame = index
    # 16番のピースは非表示
    if num == PIECE_NUM:
        piece.visible= false

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


  createPiece:function() {

  },
  /**
   * 16番ピース（空白）を取得
   * @returns {Piece}
   */
  getBlankPiece: function () {
    /** @type {Piece} */
    let result;
    this.pieceGroup.children.some(function(/** @type {Piece} */piece) {
      // 16番ピースを結果に格納I
      if (piece.num === 16) {
        result = piece;
        return true;
      }
    });
    return result;
  },
  /**
   * ピースの移動処理
   * @param {Piece} piece
   */
  movePiece: function (piece) {
    // 空白ピースを得る
    const blank = this.getBlankPiece();
    // x, yの座標差の絶対値
    const dx = Math.abs(piece.indexPos.x - blank.indexPos.x);
    const dy = Math.abs(piece.indexPos.y - blank.indexPos.y);
    // 隣り合わせの判定
    if ((piece.indexPos.x === blank.indexPos.x && dy === 1) ||
      (piece.indexPos.y === blank.indexPos.y && dx === 1)) {
      // タッチされたピース位置を記憶
      const tPos = Vector2(piece.x, piece.y);
      // ピース移動処理
      piece.tweener
           .to({x:blank.x, y:blank.y}, 100)
           .call(function() {
             blank.setPosition(tPos.x, tPos.y);
             piece.indexPos = this.coordToIndex(piece.position);
             blank.indexPos = this.coordToIndex(blank.position);
           }, this)
           .play();
    }
  },
  /**
   * 座標値からインデックス値へ変換
   * @param {Vector2} vec
   * @returns {Vector2}
   */
  coordToIndex: function (vec) {
    const x = Math.floor(vec.x / PIECE_SIZE);
    const y = Math.floor(vec.y / PIECE_SIZE);
    return Vector2(x, y);
  },
});
/**
 * ピースクラス
 * @typedef Piece
 * @property {number} num
 * @property {number} frameIndex
 * @property {Vector2} indexPos
 */
phina.define('Piece', {
  // Spriteを継承
  superClass: 'Sprite',
  /**
   * コンストラクタ
   * @constructor
   * @param {number} num
   */
  init: function (num) {
    // 親クラス初期化
    this.superInit('pieces', PIECE_SIZE, PIECE_SIZE);
    // 数字
    this.num = num;
    // フレーム
    this.frameIndex = this.num - 1;
    // 位置インデックス
    this.indexPos = Vector2.ZERO;
  },
