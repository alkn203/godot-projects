extends Node2D


# Declare member variables
const BOMB_NUM = 10
const PANEL_FRAME = 10
const BOMB_FRAME = 11 
const BOMB_EXP_FRAME = 12 

var bomb_array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var cnt = get_child_count()
	print(cnt)
	for i in range(cnt):
		if i <= BOMB_NUM:
			bomb_array.append(true)
		else:
			bomb_array.append(false)

	bomb_array.shuffle()
	# Set wether a panel has a bomb
	for panel in get_children():
		var num = panel.get_index()
		panel.is_bomb = bomb_array[num]
		
		
func open_panel(panel):
	pass
