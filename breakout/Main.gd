extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			dragging = false
	
	if event is InputEventMouseMotion and dragging:
		# While dragging, move the sprite with the mouse.
		print(event.position)
		find_node("Paddle").position.x = event.position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#var pos = get_viewport().get_mouse_position()
	#print(pos)
