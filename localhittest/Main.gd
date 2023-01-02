extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const RADIUS = 64
const pit_scene = preload("res://Pit.tscn")
const shot_scene = preload("res://Shot.tscn")

onready var enemy = get_node("Enemy")
onready var player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
  # 敵子供追加
  var deg_array = [0, 45, 90, 135, 180, 225, 270, 315]
  
  for deg in deg_array:
    var pit = pit_scene.instance()
    pit.position.x = RADIUS * cos(deg2rad(deg))
    pit.position.y = RADIUS * sin(deg2rad(deg))
    pit.deg = deg
    enemy.add_child(pit)

#
func _input(event):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT and event.pressed:
      var shot = shot_scene.instance()
      shot.position = player.position
      add_child(shot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
