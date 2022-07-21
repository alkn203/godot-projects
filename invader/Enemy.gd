extends Area2D


# Declare member variables here. Examples:
var speed = 10
var move_direction = -1
var can_move_down = false
const DOWN_DISTANCE = 32
const PROB_BEAM = 0.0002
onready var beam_scene = preload("res://Beam.tscn")
onready var beam_layer = get_node("/root/Main/BeamLayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += move_direction * speed * delta
	#
	if can_move_down:
		position.y += DOWN_DISTANCE
		can_move_down = false
	#
	if randf() < PROB_BEAM:
		var beam = beam_scene.instance()
		beam.position = position
		beam_layer.add_child(beam)
