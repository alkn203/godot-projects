extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  var arr = [
    position + Vector2(100, 0),
    position,
    position + Vector2(-100, 0),
    position]
  
  var tween = get_tree().create_tween()
  
  for pos in arr:
    tween.tween_property(self, "position", pos, 2.0)

  tween.set_loops()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
