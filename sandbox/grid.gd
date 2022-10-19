extends Node2D

class_name Grid

# 幅
var width
# 列数
var columns
# オフセット値
var offset
# 1ユニットのサイズ
var unit_width

# コンストラクタ
func _init: function() {
  width = w
  columns = col
  offset = off
  unit_width = width / columns

# スパン指定で値を取得(負数もok)
func span(index):
  return (unit_width * index) + offset

# グリッドの1単位の幅
func unit():
  return unit_width

# グリッドの中心からの相対位置で値を取得
center: function(offset) {
  var index = offset
  return (width / 2) + (unit_width * index)
