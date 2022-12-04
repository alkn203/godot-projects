extends Node2D

# 定数
const PANEL_SIZE = 64
const PANEL_NUM_XY = 9
const BOMB_NUM = 10

#　変数
var bomb_array = []

enum {NONE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, PANEL, BOMB, BOMB_EXP}

# シーン
var my_panel = preload("res://MyPanel.tscn")

# 初期化
func _ready():
  # パネル配置
  for i in range(PANEL_NUM_XY):
    for j in range(PANEL_NUM_XY):
      # パネル作成
      var panel: MyPanel = my_panel.instance()
      panel.position.x = i * PANEL_SIZE
      panel.position.y = j * PANEL_SIZE
      add_child(panel)
      
  var count: int = get_child_count()
  # 配列に爆弾情報を格納
  for i in range(count):
    if i < BOMB_NUM:
      bomb_array.append(true)
    else:
      bomb_array.append(false)
  # 乱数初期化
  randomize()
  # 配列をシャッフル
  bomb_array.shuffle()
  # パネルが爆弾かどうか設定
  for panel in get_children():
    var num: int = panel.get_index()
    panel.is_bomb = bomb_array[num]
    
# クリックされたパネルを開く
func open_panel(panel: MyPanel):
  var sprite: Sprite = panel.get_node("Sprite")
  # 爆弾
  if panel.is_bomb:
    sprite.frame = BOMB
    _show_all_bombs()
    return
  # 既に開かれていたら何もしない
  if panel.is_open:
    return
  # 開いたとフラグを立てる
  panel.is_open = true
  
  var bomb_count: int = 0;
  var index_array := [-1, 0, 1]
  # 周りのパネルの爆弾数をカウント
  for i in index_array:
    for j in index_array:
      var x: int = panel.position.x + i * PANEL_SIZE
      var y: int = panel.position.y + j * PANEL_SIZE
      var pos := Vector2(x, y)
      var target = _get_panel(pos)
      # 爆弾数カウント
      if target and target.is_bomb:
        bomb_count += 1
  # パネルに数を表示
  sprite.frame = bomb_count
  # 周りに爆弾がなければ再帰的に調べる
  if bomb_count == 0:
    for i in index_array:
      for j in index_array:
        var x: int = panel.position.x + i * PANEL_SIZE
        var y: int = panel.position.y + j * PANEL_SIZE
        var pos := Vector2(x, y)
        var target = _get_panel(pos);
        # パネルがあれば
        if target:
          open_panel(target)
          
# 指定された位置のパネルを返す
func _get_panel(pos: Vector2): 
  for panel in get_children():
    if panel.position == pos:
      return panel
  return null

# 爆弾をすべて表示する
func _show_all_bombs():
  for panel in get_children():
    var sprite: Sprite = panel.get_node("Sprite") 
    
    if panel.is_bomb:
      if sprite.frame == BOMB:
        sprite.frame = BOMB_EXP
      else:
        sprite.frame = BOMB
    # パネルをクリック不可にする		
    panel.get_node("CollisionShape2D").set_deferred("disabled", true)
