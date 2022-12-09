extends Node2D

# ノード
onready var player: Player = get_node("Player")
onready var camera: Camera2D = get_node("Camera2D")

# 毎フレーム処理
func _process(delta):
  # カメラをプレイヤーに追従させる
  camera.position.x = player.position.x
