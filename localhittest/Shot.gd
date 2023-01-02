extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 5


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  position.y -= SPEED


func _on_Shot_area_entered(area):
  if area.is_in_group("pit_group"):
    area.queue_free()
    queue_free()
