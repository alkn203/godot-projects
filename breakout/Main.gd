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
		# While dragging, move the Paddle with the mouse.
		var size_x = get_node("Paddle/Sprite").texture.get_size().x
		$Paddle.position.x = clamp(event.position.x, size_x / 2, 640 - size_x / 2)
		print(get_viewport().size.x)
#print(event.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#var pos = get_viewport().get_mouse_position()
	#print(pos)
