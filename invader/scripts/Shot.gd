# 自機のショットクラス
class_name Shot
extends Area2D

# 定数
const SPEED = 800

# シーン
const Explosion = preload("res://scenes/Explosion.tscn")
const Score = preload("res://scenes/Score.tscn")

# ノード
onready var explosion_layer: CanvasLayer = get_node("/root/Main/ExplosionLayer")
onready var score_layer: CanvasLayer = get_node("/root/Main/ScoreLayer") 

# 毎フレーム処理
func _process(delta: float) -> void:
    position.y -= SPEED * delta

# 当たり判定
func _on_Shot_area_entered(area):
    # 敵
    if area.name.find("Enemy") >= 0:
        # 爆発追加
        var explosion = Explosion.instance()
        explosion.position = area.position
        explosion_layer.add_child(explosion)
        # 敵とショットを削除
        area.queue_free()
        queue_free()
    # UFO
    if area is Ufo: 
        # スコア追加 
        var score = Score.instance() 
        score.rect_position.x = area.position.x - 32
        score.rect_position.y = area.position.y - 16
        score_layer.add_child(score) 
        # UFOとショットを削除 
        area.queue_free() 
        queue_free()
