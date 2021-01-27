extends Node2D
class_name Unit

export var INIT_BOARD_POS: Vector2

enum UNIT_TYPE {PLAYER, ENEMY, PROP, PORTAL}

onready var m_nRoom = get_parent().get_parent()
onready var m_vBoardPos: Vector2
onready var m_bIsFacingRight: bool = true

# Overrider these in child scripts' _init() function
# ================================
var m_iUnitType: int
var m_bCanShareTile: bool
# ================================

# Every unit require this function when
# they first get put into the room
func set_board_pos(_boardPos: Vector2) -> void:
	if !m_nRoom.is_tile_empty(_boardPos):
		return
		
	var targetTile: Tile = m_nRoom.get_tile(_boardPos)
	match m_iUnitType:
		UNIT_TYPE.PLAYER:
			if !targetTile.type in [Tile.TILE_TYPE.PLAYER, Tile.TILE_TYPE.COMMON]:
				return
		_:
			pass
	global_position = targetTile.global_position
	m_vBoardPos = _boardPos
	m_nRoom.emit_signal("unit_moved", m_iUnitType, m_vBoardPos)

# This function is called each time the
# "tile_damaged" signal is emitted from
# the "Room" node
func _on_tile_damaged(_tilePos: Vector2, _isPlayerDmg: bool) -> void:
	if _tilePos == m_vBoardPos:
		pass

func _set_facing_right(_isFacingRight: bool) -> void:
	scale.x = abs(scale.x) * (1 if _isFacingRight else -1)
	m_bIsFacingRight = _isFacingRight
