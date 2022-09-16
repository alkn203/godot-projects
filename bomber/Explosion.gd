extends Area2D

# Declare member variables here. Examples:
var tile_pos = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# フレームアニメーションが終わったら自身を削除
func _on_AnimatedSprite_animation_finished():
	queue_free()
