extends Node2D

# 画像スプライト情報
enum {NONE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, PANEL, BOMB, BOMB_EXP}

# 定数
const PANEL_SIZE = 64
const PANEL_NUM_X = 9
const PANEL_NUM = PANEL_NUM_X * PANEL_NUM_X
const BOMB_NUM = 10

# シーン
const MyPanel: PackedScene = preload("res://MyPanel.tscn")

#　変数
var bomb_array: Array = []

# 初期化
func _ready() -> void:
  # パネル作成・配置
  _create_panel()

# パネル作成
_create_panel() -> void:
  for i in PANEL_NUM:
    # グリッド配置用のインデックス値算出
    var gx: int = i % PANEL_NUM_X
    var gy: int = int(i / PANEL_NUM_X)
    # パネル作成
    var panel: MyPanel = MyPanel.instance()
    panel.position.x = gx * PANEL_SIZE
    panel.position.y = gy * PANEL_SIZE
    # インデックス位置
    panel.index_pos = Vector2(gx, gy)
    # シーンに追加
    add_child(panel)
      
  # 配列に爆弾情報を格納
  for i in PANEL_NUM:
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
func open_panel(panel: MyPanel) -> void:
  var sprite: Sprite = panel.get_node("Sprite")
  # 爆弾
  if panel.is_bomb:
    sprite.frame = BOMB
    # 隠された爆弾を表示
    _show_all_bombs()
    return

  # 既に開かれていたら何もしない
  if panel.is_open:
    return

  # 開いたとフラグを立てる
  panel.is_open = true
  # 爆弾カウント用
  var bomb_count: int = 0;
  var index_array: Array = [-1, 0, 1]
  # 周りのパネルの爆弾数をカウント
  for i in index_array:
    for j in index_array:
      var pos = panel.index_pos + Vector2(i, j)
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
        var pos = panel.index_pos + Vector2(i, j)
        var target = _get_panel(pos);
        # パネルがあれば
        if target:
          open_panel(target)
          
# 指定されたインデックス位置のパネルを返す
func _get_panel(pos: Vector2): 
  for panel in get_children():
    if panel.index_pos == pos:
      return panel
  return null

# 爆弾をすべて表示する
func _show_all_bombs() -> void:
  for panel in get_children():
    var sprite: Sprite = panel.get_node("Sprite") 
    # 隠された爆弾を表示
    if panel.is_bomb:
      if sprite.frame == BOMB:
        sprite.frame = BOMB_EXP
      else:
        sprite.frame = BOMB

    # パネルをクリック不可にする		
    panel.get_node("CollisionShape2D").set_deferred("disabled", true)
