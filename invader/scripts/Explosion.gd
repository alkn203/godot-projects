# 敵の爆発クラス
class_name Explosion
extends AnimatedSprite

# アニメーションが終わったら自身を消す
func _on_Explosion_animation_finished() -> void:
    queue_free()
