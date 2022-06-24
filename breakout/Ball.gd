extends RigidBody2D


export (float) var ball_speed = 150.0
var direction: Vector2
var velocity: Vector2

func _ready():
	direction = Vector2(1, -1).normalized()
	velocity = direction * ball_speed
	apply_impulse(Vector2.ZERO, velocity)


func _on_Ball_body_entered(body):
	
	direction = linear_velocity.normalized()
	velocity = direction * ball_speed
	
	if body.is_in_group("Bricks"):
		body.queue_free()
		
	if body.get_name() == "Paddle":
		direction = (position - body.position).normalized()
		velocity = direction * ball_speed
	
	linear_velocity = velocity # 一番下に移動
