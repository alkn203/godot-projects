extends StaticBody2D


# Declare member variables here. Examples:
# タイルマップ上の位置
var tile_pos = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("fadeout")

# アニメーションが終わったら自身を削除
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
