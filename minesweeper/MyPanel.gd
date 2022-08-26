extends Area2D
class_name MyPanel


# Declare member variables here.
var is_bomb: bool = false
var is_open: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Panel_input_event(viewport, event, shape_idx):
	# マウス入力イベントが発生 
	if event is InputEventMouseButton: 
		# マウスボタン押下イベント 
		if event.is_pressed(): 
			get_parent().open_panel(self)
