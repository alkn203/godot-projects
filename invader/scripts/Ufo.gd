# UFOクラス
class_name Ufo
extends Area2D

# 定数
const SPEED = 100

# 毎フレーム処理
func _process(delta: float) -> void:
    position.x -= SPEED * delta
