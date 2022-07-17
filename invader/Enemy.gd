extends Area2D


# Declare member variables here. Examples:
var speed = 16
var move_direction = -1
var move_down_distance = 32;
var can_move_down = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += move_direction * speed * delta
	# move down flag
	if can_move_down:
		position.y += move_down_distance
		can_move_down = false
