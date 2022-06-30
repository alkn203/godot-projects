extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta


# Check collision
func _on_Shot_area_entered(area):
	print("test")
	# If target is enemy, destroy it.
	if area.is_in_group("Enemys"):
		area.queue_free()
		queue_free()
