extends Node2D

# リソース
const data = preload("res://Xolonium-Regular.ttf")

# ノード
onready var anim = get_node("AnimationPlayer")
onready var title_label = get_node("TitleLabel")
onready var start_label = get_node("StartLabel")

# 初期化処理
func _ready() -> void:
    # タイトルラベルフォント設定
    var title_font: DynamicFont = DynamicFont.new()
    title_font.font_data = data
    title_label.set("custom_fonts/font", title_font)
    title_label.get("custom_fonts/font").set_size(48)
    # スタートラベルフォント設定
    var start_font: DynamicFont = DynamicFont.new()
    start_font.font_data = data
    start_label.set("custom_fonts/font", start_font)
    start_label.get("custom_fonts/font").set_size(32)
    # 文字のフェードインアウト
    anim.play("fadeout_in")

# 毎フレーム処理
func _process(delta) -> void:
    # スペースキーでスタート
    if Input.is_action_just_pressed("space_key"):
        get_tree().change_scene("res://scenes/Main.tscn")
