extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 200
onready var explosion_scene = preload("res://Explosion.tscn")
onready var explosion_layer = get_node("/root/Main/ExplosionLayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta


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
