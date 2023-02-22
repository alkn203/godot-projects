extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
  anim.play("fadeout_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Input.is_action_just_pressed("space_key"):
    get_tree().change_scene("res://scenes/Main.tscn")
