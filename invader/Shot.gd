extends Area2D


# Declare member variables here. Examples:
var speed = 800
onready var explosion_scene = preload("res://Explosion.tscn")
onready var explosion_layer = get_node("/root/Main/ExplosionLayer")
onready var score_scene = preload("res://Score.tscn") 
onready var score_layer = get_node("/root/Main/ScoreLayer") 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta
	

# Check collision
func _on_Shot_area_entered(area):
	# If target is enemy, destroy it.
	if area.is_in_group("Enemys"):
		# Add explosion to enemy's position
		var explosion = explosion_scene.instance()
		explosion.position = area.position
		explosion_layer.add_child(explosion)
		# Delete enemy and shot
		area.queue_free()
		queue_free()
	# If target is ufo, destroy it. 
	if area.is_in_group("Ufos"): 
		# Add score to ufo's position 
		var score = score_scene.instance() 
		score.rect_position.x = area.position.x - 32
		score.rect_position.y = area.position.y - 16
		score_layer.add_child(score) 
		# Delete ufo and shot 
		area.queue_free() 
		queue_free()
