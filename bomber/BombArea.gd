extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tile_pos = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BombArea_body_exited(body):
	if body.name == "Player":
        # bit 2:Bombとの当たり判定を有効に
	body.set_collision_mask_bit(2, true)
        queue_free() 
