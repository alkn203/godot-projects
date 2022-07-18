extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var enemy_layer = get_node("/root/Main/EnemyLayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WallLeft_area_entered(area):
	if area.is_in_group("Enemys"):
		for enemy in enemy_layer.get_children():
			enemy.move_direction = 1
			enemy.can_move_down = true
