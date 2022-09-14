extends StaticBody2D


# Declare member variables here. Examples:
var tile_pos = Vector2(0, 0)

onready var stage = get_node("/root/Main/Stage1")


# Called when the node enters the scene tree for the first time.
func _ready():
        # 3秒後に爆発
	yield(get_tree().create_timer(3.0), "timeout")
        stage.explode(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
