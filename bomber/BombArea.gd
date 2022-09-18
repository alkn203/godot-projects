extends Area2D

# タイルマップでの位置
var tile_pos = Vector2(0, 0)

# Areaから出たNodeを検出
func _on_BombArea_body_exited(body):
	if body.name == "Player":
		# bit 2:Bombとの当たり判定を有効に
		body.set_collision_mask_bit(2, true)
		# 自身を削除
		queue_free() 
