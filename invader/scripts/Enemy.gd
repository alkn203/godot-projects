# 敵クラス
class_name Enemy
extends Area2D

# 定数
const PROB_BEAM = 0.0002

# シーン
const Beam = preload("res://scenes/Beam.tscn")

# ノード
onready var beam_layer: CanvasLayer = get_node("/root/Main/BeamLayer")

# 毎フレーム処理
func _process(delta: float) -> void:
    # 一定の確率でビーム発射
    if randf() < PROB_BEAM:
        var beam = Beam.instance()
        beam.position = position
        beam_layer.add_child(beam)
