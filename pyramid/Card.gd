class_name Card
extends Area2D

# 定数
const DURATION = 0.15

# 変数
var index: int = 0
var num: int = 0

# ノード
onready var main: Node2D = get_node("/root/Main")

# マウスクリック時イベント
func _on_Card_input_event(viewport, event, shape_idx) -> void:
    # マウス入力イベントが発生
    if event is InputEventMouseButton:
        # マウスボタンの押下イベント
        if event.is_pressed():
            # 開いてない手札の場合
            if is_in_group("hand"):
                main.open_hand_card()
            # ペアとして選択可能な場合
            if is_in_group("selectable"):
                main.add_pair(self)

# インデックスと数字セット
func set_index_num(idx: int) -> void:
    index = idx
    num = index % 13 + 1

# 移動とカード返し処理
func slide_and_flip(pos: Vector2) -> void:
    var tween = get_tree().create_tween()
    # 指定した位置に移動
    tween.tween_property(self, "position", pos, DURATION)
    # 縮小
    tween.tween_property(self, "scale", Vector2(0.1, 1.0), DURATION)
    # 絵柄セット
    tween.tween_callback(self, "_set_frame_index")
    # 拡大
    tween.tween_property(self, "scale", Vector2(1.0, 1.0), DURATION)
    # 選択可能グループに追加
    tween.tween_callback(self, "add_to_group", ["selectable"])

# 移動処理
func slide_to(pos: Vector2) -> void:
    var tween = get_tree().create_tween()
    # 指定した位置に移動
    tween.tween_property(self, "position", pos, DURATION)
    # 捨て札の最上部グループに追加
    tween.tween_callback(main, "_selectable_drop_top")
  
# カード表の画像フレームをセット
func _set_frame_index() -> void:
    get_node("Sprite").frame = index
