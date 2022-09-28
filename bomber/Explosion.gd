extends Area2D

# タイルマップでの位置
var tile_pos = Vector2(0, 0)

# フレームアニメーションが終わったら自身を削除
func _on_AnimatedSprite_animation_finished():
	queue_free()

#
func _on_Explosion_body_entered(body):
	body.disable()
