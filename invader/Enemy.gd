extends Area2D


# Declare member variables here. Examples:
var speed = 8
var move_direction = -1
#onready var enemy_layer = get_node("/root/Main/EnemyLayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += move_direction * speed * delta
