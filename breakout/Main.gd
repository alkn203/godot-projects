extends Node2D

# 定数
const BLOCK_WIDTH = 64
const BLOCK_HEIGHT = 32
const BLOCK_NUM_X = 8
const BLOCK_NUM = 48
const OFFSET_X = BLOCK_WIDTH / 2
const OFFSET_Y = BLOCK_HEIGHT / 2

# シーン
const Block: PackedScene = preload("res://Block.tscn")

# 変数

# 初期化処理
func _ready():
    # ブロック配置
    _create_block()

# ブロック配置
func _create_block() -> void:
    for i in BLOCK_NUM:
        # グリッド配置用のインデックス値算出
        var gx: int = i % BLOCK_NUM_X
        var gy: int = int(i / BLOCK_NUM_X)
        # ブロック作成
        var block: Block = Block.instance()
        # 配置
        block.position.x = gx * BLOCK_WIDTH + OFFSET_X + BLOCK_WIDTH
        block.position.y = gy * BLOCK_HEIGHT + OFFSET_Y + BLOCK_HEIGHT
        add_child(block)
        # 画像変更
        if i > 15:
            block.get_node("Sprite").frame = 1
        if i > 31:
            block.get_node("Sprite").frame = 2

# スクリーンから出たオブジェクトを補足
func _on_Screen_body_exited(body) -> void:
    # ボールの場合
    if body is Ball:
        # ゲーム再ロード
        get_tree().change_scene("res://Main.tscn")
