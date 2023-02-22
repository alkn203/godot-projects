extends Node2D

# 定数
const ENEMY_NUM = 40
const ENEMY_NUM_X = 8
const ENEMY_SIZE = 64

# シーン
const Enemy = preload("res://scenes/Enemy.tscn")
const Ufo = preload("res://scenes/Ufo.tscn")

# 変数
onready var screen_size: Vector2 = get_viewport_rect().size
onready var ufo_layer: CanvasLayer = get_node("UfoLayer")
onready var ufo_timer: Timer = get_node("UfoTimer") 
onready var enemy_layer: CanvasLayer = get_node("EnemyLayer")

# 初期化処理
func _ready() -> void:
    # 敵作成
    _create_enemy()

# 敵作成
func _create_enemy() -> void:
    for i in ENEMY_NUM:
        # グリッド配置用のインデックス値算出
        var gx: int = i % ENEMY_NUM_X
        var gy: int = int(i / ENEMY_NUM_X)
        # 敵作成
        var enemy: Enemy = Enemy.instance()
        enemy.position.x = gx * ENEMY_SIZE
        enemy.position.y = gy * ENEMY_SIZE
        # シーンに追加
        enemy_layer.add_child(enemy)

# 毎フレーム処理
func _process(delta: float) -> void:
    # UFOの出現管理
    if ufo_timer.is_stopped():
        var ufo = Ufo.instance()
        ufo.position = Vector2(screen_size.x, 64)
        ufo_layer.add_child(ufo)
        ufo_timer.start()
