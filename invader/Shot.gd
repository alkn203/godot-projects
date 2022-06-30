extends Area2D


# Declare member variables here. Examples:
var speed = 200
onready var size_y = find_node("Sprite").texture.get_size().y 
onready var explosion_scene = preload("res://Explosion.tscn")
onready var explosion_layer = get_node("/root/Main/ExplosionLayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta
	# Remove if goes outside of screen
	if position.y < -size_y:
		queue_free()
	

# Check collision
func _on_Shot_area_entered(area):
	# If target is enemy, destroy it.
	if area.get_parent().name == "EnemyLayer":
		# Add explosion to enemy's position
		var explosion = explosion_scene.instance()
		explosion.position = area.position
		explosion_layer.add_child(explosion)
		# Delete enemy and shot
		area.queue_free()
		queue_free()
