extends Node2D

# 定数
const GEM_SIZE = 80
const GEM_OFFSET = GEM_SIZE / 2
const GEM_NUM_X = 8

# 変数
# ペア格納用配列
var pair = []
# シーン
const Gem = preload("res://Gem.tscn")
# レイヤー
onready var gem_layer = get_node("GemLayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	# ジェム配置
	for i in GEM_NUM_X:
		for j in GEM_NUM_X:
			var gem = Gem.instance()
			gem.position = Vector2(i * GEM_SIZE, j * GEM_SIZE) + Vector2(GEM_OFFSET, GEM_OFFSET)
			gem_layer.add_child(gem)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# ペア選択処理
func select_pair(gem):
	print(gem.name)
	
