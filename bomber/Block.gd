extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# タイルマップ上の位置
var tile_pos = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("fadeout")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# アニメーションが終わったら自身を削除
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
