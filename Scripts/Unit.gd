extends Node2D
class_name Unit

export var initBoardPos: Vector2

enum UNIT_TYPE {PLAYER, ENEMY, PROP, PORTAL}

onready var room: Room = get_parent().get_parent()
onready var boardPos: Vector2

# Overrider these in child scripts
# ================================
var unitType: int
var canShareTile: bool
# ================================

# Every unit require this function when
# they first get put into the room
func set_board_pos(_boardPos: Vector2) -> void:
	if room.is_tile_empty(_boardPos):
		var targetTile: Tile = room.get_tile(_boardPos)
		if targetTile.type in [Tile.TILE_TYPE.PLAYER, Tile.TILE_TYPE.COMMON]:
			global_position = targetTile.global_position
			boardPos = _boardPos
			room.emit_signal("unit_moved", unitType, boardPos)

# This function is called each time the
# "tile_damaged" signal is emitted from
# the "Room" node
func _on_tile_damaged(tilePos: Vector2, isPlayerDmg: bool) -> void:
	if tilePos == boardPos:
		pass
