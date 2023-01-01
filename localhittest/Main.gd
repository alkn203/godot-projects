extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pit_scene = preload("res://Pit.tscn")

onready var enemy = get_node("Enemy")

# Called when the node enters the scene tree for the first time.
func _ready():
  # 敵子供追加
  var deg_array = [0, 45, 90, 135, 180, 225, 270, 315]
  
  for deg in deg_array:
    var pit = pit_scene.instance()
    pit.position.x = 64 * cos(deg2rad(deg))
    pit.position.y = 64 * sin(deg2rad(deg))
    pit.deg = deg
    enemy.add_child(pit)
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
