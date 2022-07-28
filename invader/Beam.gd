extends Area2D


# Declare member variables here. Examples:
var speed = 50 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta


func _on_Beam_area_entered(area):
	# If target is player
	if area.name == "Player":
		get_tree().paused = true
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().paused = false
		get_tree().change_scene("res://Title.tscn")
