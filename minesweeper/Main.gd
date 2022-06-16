extends Node2D


# Declare member variables
const PANEL_SIZE = 64
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
		
# 		
func open_panel(panel):
	# Get Sprite node
	var sprite = panel.find_node("Sprite")
	# If the panel has a bomb
	if panel.is_bomb:
		sprite.set("frame",  BOMB_EXP_FRAME)
		#this.showAllBombs()
		return

	# Do nothing if it is already open
	if panel.is_open:
		return
	# Flag as open
	panel.is_open = true
	#this.oCount++
	var count = 0
	var index_array = [-1, 0, 1]
	# Count the number of bombs on the surrounding panels
	for i in index_array:
		for j in index_array:
			var x = panel.position.x + i * PANEL_SIZE 
			var y = panel.position.y + j * PANEL_SIZE 
			var target = get_panel(x, y)
			# 
			if target != null and target.is_bomb:
				count += 1
	# Show a number on the panel
	sprite.set("frame", count)
	# Recursively look up if there are no bombs around
	if count == 0:
		for i in index_array:
			for j in index_array:
				var x = panel.position.x + i * PANEL_SIZE
				var y = panel.position.y + j * PANEL_SIZE
				var target = get_panel(x, y)
				if target:
					open_panel(target)
					
# Get the panel specified by position
func get_panel(x, y):
	var result = null
	for panel in get_children():
		if (panel.position.x == x) and (panel.position.y == y):
			result = panel
	return result
