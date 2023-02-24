# Blockクラス
class_name Block
extends Node2D

# 変数
var type: int = 0
var drop_count: int = 0
var index_pos: Vector2 = Vector2.ZERO
var mark: String = "normal"

# グレイスケール化
func greyscale():
    get_node("Sprite").material.set_shader_param("greyscale", true)
