extends Node2D
class_name Tile

enum TileType { EMPTY, COMMON, PLAYER, ENEMY }

onready var tileType: int = 0 setget _on_tile_type_change

func _on_tile_type_change(_tileType) -> void:
	for i in range(TileType.size()):
		get_child(i).visible = true if i == _tileType else false
	tileType = _tileType
