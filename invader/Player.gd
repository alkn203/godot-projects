extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		# Move as long as the key/button is pressed.
		position.x += speed * delta
	if Input.is_action_pressed("ui_left"):
		# Move as long as the key/button is pressed.
		position.x -= speed * delta
