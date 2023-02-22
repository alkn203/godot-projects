# スコアクラス
class_name Score
extends Label

# 初期化処理
func _ready() -> void:
    # 一定時間で削除
    yield(get_tree().create_timer(1.0), "timeout")
    queue_free()
