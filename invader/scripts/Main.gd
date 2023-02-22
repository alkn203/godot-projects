extends Node2D

# シーン
const Ufo = preload("res://scenes/Ufo.tscn")

# 変数
onready var screen_size: Vector2 = get_viewport_rect().size
onready var ufo_layer: CanvasLayer = get_node("UfoLayer")
onready var ufo_timer: Timer = get_node("UfoTimer") 

# 毎フレーム処理
func _process(delta: float) -> void:
    # UFOの出現管理
    if ufo_timer.is_stopped():
        var ufo = Ufo.instance()
        ufo.position = Vector2(screen_size.x, 64)
        ufo_layer.add_child(ufo)
        ufo_timer.start()
