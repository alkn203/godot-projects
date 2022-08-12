extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

onready var bomb_scene = preload("res://Bomb.tscn")
onready var bomb_layer = get_node("/root/Main/Stage1/BombLayer")
onready var tilemap = get_node("/root/Main/Stage1/TileMap")

func get_move_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_move_input()
	velocity = move_and_collide(velocity * delta)
	
	if Input.is_action_just_pressed("ui_z"):
		print(position.x / 64)
		print(position.y / 64)
		set_bomb() 

func set_bomb(): 
	var bomb = bomb_scene.instance()
	bomb.tile_pos = tilemap.global_to_map(position)
	bomb.position = tilemap.map_to_global(bomb.tile_pos)
	bomb_layer.add_child(bomb)
