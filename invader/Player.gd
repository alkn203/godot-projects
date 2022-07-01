extends Area2D


# Declare member variables here. Examples:
var speed = 100
onready var shot_scene = preload("res://Shot.tscn")
onready var shot_layer = get_node("/root/Main/ShotLayer")
onready var shot_timer = get_node("ShotTimer") 


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
	if Input.is_action_just_pressed("space_key") and shot_timer.is_stopped():
		# shoot
		var shot = shot_scene.instance()
		shot.position = position
		shot_layer.add_child(shot)
		#
		shot_timer.start()
