extends Node2D


# Declare member variables here. Examples:
const TILE_SIZE = 64
const BAGGAGE_POS = [Vector2(4, 7), Vector2(4, 6)]
onready var baggage_layer = get_node("BaggageLayer")
onready var baggage_scene = preload("res://Baggage.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	for pos in BAGGAGE_POS:
		var baggage = baggage_scene.instance()
		baggage.tile_pos = pos
		baggage.position = pos * TILE_SIZE
		baggage_layer.add_child(baggage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
