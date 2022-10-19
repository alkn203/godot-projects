extends Node2D

class_name Grid

# 幅
var width: float
# 列数
var columns: int
# オフセット値
var offset: float
# 1ユニットのサイズ
var unit_width: float

# コンストラクタ
func _init(float: w, int: col, int: offset = 0):
  width = w
  columns = col
  offset = off
  unit_width = width / columns

# スパン指定で値を取得(負数もok)
func span(float: index): -> float
  return (unit_width * index) + offset

# グリッドの1単位の幅
func unit(): -> float
  return unit_width

# グリッドの中心からの相対位置で値を取得
center(float: offset = 0): -> float
  return (width / 2) + (unit_width * offset)
