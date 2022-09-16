extends KinematicBody2D

export (int) var speed = 120

var velocity = Vector2(0, 0)

onready var bombarea_scene = preload("res://BombArea.tscn")
onready var bomb_scene = preload("res://Bomb.tscn")

onready var main = get_node("/root/Main")
onready var bombarea_layer = get_node("/root/Main/BombAreaLayer")
onready var bomb_layer = get_node("/root/Main/BombLayer")


func _physics_process(delta):
	get_move_input()
	var collision = move_and_collide(velocity * delta)
	
	if Input.is_action_just_pressed("ui_z"):
		set_bomb() 

func get_move_input():
	velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	velocity = velocity.normalized() * speed


func set_bomb(): 
	set_collision_mask_bit(2, false)
	var bombarea = bombarea_scene.instance()
	main.locate_object(bombarea, main.global_to_map(position))
	bombarea_layer.add_child(bombarea)

	var bomb = bomb_scene.instance()
	main.locate_object(bomb, main.global_to_map(position))
	bomb_layer.add_child(bomb)
