extends RigidBody2D


# Declare member variables here. Examples:
export (float) var ball_speed = 250
var direction: Vector2
var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2(0, 1)
	velocity = direction * ball_speed
	apply_impulse(Vector2.ZERO, velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ball_body_entered(body):
	# ブロックとの衝突
	if body.is_in_group("Blocks"):
		body.queue_free()
	# パドルとの衝突
	if body.get_name() == "Paddle":
		# 衝突位置で反射角度を変える
		direction = (position - body.position).normalized()
		velocity = direction * ball_speed
		linear_velocity = velocity
