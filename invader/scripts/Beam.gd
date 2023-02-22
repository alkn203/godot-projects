# 敵のビームクラス
class_name Beam 
extends Area2D

# 変数
var speed: int = 50 

# 毎フレーム処理
func _process(delta: float) -> void:
    position.y += speed * delta

# プレイヤーとの当たり判定
func _on_Beam_area_entered(area) -> void:
    if area is Player:
        # 画面をポーズ
        get_tree().paused = true
        # 一定時間経過後タイトルへ
        yield(get_tree().create_timer(1.0), "timeout")
        get_tree().paused = false
        get_tree().change_scene("res://scenes/Title.tscn")
