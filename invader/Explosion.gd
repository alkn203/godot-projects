# Explosionクラス
extends AnimatedSprite

# アニメーションが終わったら自身を消す
func _on_Explosion_animation_finished():
    queue_free()
