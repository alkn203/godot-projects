extends Node2D


# Declare member variables here. Examples:
onready var screen_size = get_viewport_rect().size
onready var shot_scene = preload("res://Ufo.tscn")
onready var ufo_layer = find_node("UfoLayer")
onready var ufo_timer = get_node("UfoTimer") 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#
	if ufo_timer.is_stopped():
		var ufo = shot_scene.instance()
		ufo.position = Vector2(screen_size.x, 64)
		ufo_layer.add_child(ufo)
		ufo_timer.start()
