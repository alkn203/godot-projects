# 自機のショットクラス
class_name Shot
extends Area2D

# 定数
const SPEED = 800

# シーン
const Explosion = preload("res://Explosion.tscn")
condt Score = preload("res://Score.tscn") 

# ノード
onready var explosion_layer: CanvasLayer = get_node("/root/Main/ExplosionLayer")
onready var score_layer: CanvasLayer = get_node("/root/Main/ScoreLayer") 

# 毎フレーム処理
func _process(delta: float) -> void:
    position.y -= SPEED * delta

# 当たり判定
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
