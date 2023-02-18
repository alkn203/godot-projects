extends Node2D

# タイル情報
enum { TILE_NONE, TILE_FLOOR, TILE_GOAL, TILE_WALL, BAGGAGE, BAGGAGE_ON_GOAL } 

# 定数
const TILE_SIZE = 64
const BAGGAGE_POS = [Vector2(4, 7), Vector2(4, 6)]
const DURATION = 0.25
const KEY_ARRAY = [
    ["ui_down", Vector2.DOWN],
    ["ui_up", Vector2.UP],
    ["ui_left", Vector2.LEFT],
    ["ui_right", Vector2.RIGHT]]

# ノード
onready var tilemap: TileMap = get_node("TileMap")
onready var baggage_layer: CanvasLayer = get_node("BaggageLayer")

# シーン
onready var baggage_scene = preload("res://Baggage.tscn")

# 初期化処理
func _ready() -> void:
    # 荷物配置
    for pos in BAGGAGE_POS:
        var baggage: Baggage = baggage_scene.instance()
        baggage.tile_pos = pos
        baggage.position = pos * TILE_SIZE
        baggage_layer.add_child(baggage)

# 指定位置の荷物を返す
func get_baggage_by_pos(pos):
    for baggage in baggage_layer.get_children():
        if baggage.tile_pos == pos:
            return baggage
    # 荷物がない場合
    return null

# ゴールに乗っている荷物の色を変える 
func change_baggage_color_on_goal() -> void:
    for baggage in baggage_layer.get_children():
        if tilemap.get_cellv(baggage.tile_pos) == TILE_GOAL:
            baggage.frame = BAGGAGE_ON_GOAL
        else:
            baggage.frame = BAGGAGE

# クリアチェック 
func is_clear() -> bool:
    for baggage in baggage_layer.get_children():
        if baggage.frame == BAGGAGE:
            return false
    return true


# 定数


# 変数
var tile_pos: Vector2 = Vector2(4, 8)
var can_input: bool = true

# ノード
onready var stage: Node2D = get_node("/root/Main")
onready var tilemap: TileMap = get_node("/root/Main/TileMap")
onready var baggage_layer: CanvasLayer = get_node("/root/Main/BaggageLayer")

# 毎フレーム処理
func _process(delta) -> void:
    # キー入力不可の場合
    if can_input == false:
        return
      
    var velocity: Vector2 = Vector2.ZERO
  
    for elem in KEY_ARRAY:
        var dir: String = elem[0]
        # キーにより方向振り分け
        if Input.is_action_pressed(dir):
            play(dir)
            velocity = elem[1]
    # 何かしら入力があれば
    if velocity.x != 0 or velocity.y != 0:
        # tween作成
        var tween: SceneTreeTween = get_tree().create_tween()
        # その方向の一つ先の位置
        var next: Vector2 = tile_pos + velocity
        # 壁なら何もしない
        if tilemap.get_cellv(next) == TILE_WALL:
            return
    
        # 隣が荷物かどうか調べる
        var baggage = stage.get_baggage_by_pos(next)
        # 荷物の場合
        if baggage != null:
            # 荷物のその１つ先が壁
            if tilemap.get_cellv(next + velocity) == TILE_WALL:
                return
            # 荷物のその１つ先が荷物
            if stage.get_baggage_by_pos(next + velocity) != null:
                return
      
            # 荷物位置更新
            baggage.tile_pos += velocity
            var pos: Vector2 = baggage.position + velocity * TILE_SIZE
            tween.set_parallel(true)
            tween.tween_property(baggage, "position", pos, DURATION)
      
        # プレイヤー位置更新
        tile_pos = next
        # 一旦入力不可にする
        can_input = false
        # 移動アニメーション
        tween.tween_property(self, "position", position + velocity * TILE_SIZE, DURATION)
        tween.set_parallel(false)
        tween.tween_callback(self, "_after_move")

# 移動後処理
func _after_move() -> void:
    can_input = true
    # 荷物がゴールに乗っているかのチェック
    stage.change_baggage_color_on_goal()
    # クリアチェック
    if stage.is_clear() == true:
        OS.alert("clear")

