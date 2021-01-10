extends Node2D
class_name Tile

enum TILE_TYPE { EMPTY, COMMON, PLAYER, ENEMY }
const FLASH_TIME: float = 0.1

onready var type: int = 0 setget set_type

func set_type(_type) -> void:
	for i in range(TILE_TYPE.size()):
		$Types.get_child(i).visible = true if i == _type else false
	type = _type

func flash(_type) -> void:
	match _type:
		TILE_TYPE.PLAYER:
			$Flashs/YellowFlash.visible = true
		TILE_TYPE.ENEMY:
			$Flashs/RedFlash.visible = true
		_:
			assert(false)
	yield(get_tree().create_timer(FLASH_TIME), "timeout")
	for child in $Flashs.get_children():
		child.visible = false
