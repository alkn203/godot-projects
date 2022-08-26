extends Area2D


# Declare member variables here.
var is_bomb = false
var is_open = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Panel_input_event(viewport, event, shape_idx):
	# マウスボタンの入力イベント
	if event is InputEventMouseButton: 
		if event.is_pressed(): 
			get_parent().open_panel(self)
