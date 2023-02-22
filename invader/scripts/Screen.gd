extends Area2D

# スクリーンを出たオブジェクトを削除する
func _on_Screen_area_exited(area) -> void:
    area.queue_free()
