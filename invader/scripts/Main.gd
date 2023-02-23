extends Node2D

# 定数
const ENEMY_NUM = 45
const ENEMY_NUM_X = 9
const ENEMY_SIZE = 64
const ENEMY_OFFSET = 64
const ENEMY_HALF = ENEMY_SIZE / 2
const ENEMY_SPEED = 10

# シーン
const Enemy = preload("res://scenes/Enemy.tscn")
const Ufo = preload("res://scenes/Ufo.tscn")

# 変数
var dir: int = -1
onready var screen_size: Vector2 = get_viewport_rect().size
onready var ufo_layer: CanvasLayer = get_node("UfoLayer")
onready var ufo_timer: Timer = get_node("UfoTimer") 
onready var enemy_layer: CanvasLayer = get_node("EnemyLayer")

# 初期化処理
func _ready() -> void:
    # 敵作成
    _create_enemy()

# 毎フレーム処理
func _process(delta: float) -> void:
    # 敵移動
    _move_enemy(delta)
    # UFOの出現管理
    if ufo_timer.is_stopped():
        var ufo = Ufo.instance()
        ufo.position = Vector2(screen_size.x, 64)
        ufo_layer.add_child(ufo)
        ufo_timer.start()

# 敵作成
func _create_enemy() -> void:
    for i in ENEMY_NUM:
        # グリッド配置用のインデックス値算出
        var gx: int = i % ENEMY_NUM_X
        var gy: int = int(i / ENEMY_NUM_X)
        # 敵作成
        var enemy: Enemy = Enemy.instance()
        enemy.position.x = gx * ENEMY_SIZE + ENEMY_OFFSET
        enemy.position.y = gy * ENEMY_SIZE + ENEMY_OFFSET
        # シーンに追加
        enemy_layer.add_child(enemy)

# 敵移動
func _move_enemy(delta: float) -> void:
    for enemy in enemy_layer.get_children():
        # 移動
        enemy.position.x += dir * ENEMY_SPEED * delta
        # 画面端で反転
        var x: float = enemy.position.x
        if (x - ENEMY_HALF) < 0 or (x + ENEMY_HALF) > screen_size.x:
            dir *= -1
            # 縦移動
            _move_enemy_down()
            return

# 敵縦移動
func _move_enemy_down() -> void:
    for enemy in enemy_layer.get_children():
        enemy.position.y += ENEMY_HALF
        
