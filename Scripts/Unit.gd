extends Node2D
class_name Unit

enum UNIT_TYPE {PLAYER, ENEMY, PROP, PORTAL}

export var INIT_BOARD_POS: Vector2

onready var m_nRoom = get_parent().get_parent()
onready var m_vBoardPos: Vector2
onready var m_bIsFacingRight: bool = true

# Overrider these in child scripts' _init() function
# ==================================================
var m_iUnitType: int
var m_bCanShareTile: bool
# ==================================================

# Common functions for all units
# ==============================
func set_board_pos(_boardPos: Vector2) -> void:
	if !m_nRoom.is_tile_empty(_boardPos):
		return
	
	var targetTile: Tile = m_nRoom.get_tile(_boardPos)
	if m_iUnitType == UNIT_TYPE.PLAYER:
		if !targetTile.type in [Tile.TILE_TYPE.PLAYER, Tile.TILE_TYPE.COMMON]:
			return
	
	global_position = targetTile.global_position
	m_vBoardPos = _boardPos

func _set_facing_right(_isFacingRight: bool) -> void:
	scale.x = abs(scale.x) * (1 if _isFacingRight else -1)
	m_bIsFacingRight = _isFacingRight

func _on_tile_damaged(_tilePos: Vector2, _isPlayerDmg: bool) -> void:
	if _tilePos == m_vBoardPos:
		if (m_iUnitType == UNIT_TYPE.PLAYER and !_isPlayerDmg) or _isPlayerDmg:
			_receive_damage()

# Virtual methods
# ===============
func _receive_damage() -> void:
	pass
func _play_anim_and_deal_damage(_animName: String) -> void:
	pass
# ===============

# Common functions for enemy units
# ================================
func _set_facing_to_player() -> void:
	var playerPos: Vector2 = m_nRoom.get_player_pos()
	_set_facing_right(!(playerPos.y < m_vBoardPos.y))

func _set_pos_align_with_player(_sameSideAsPlayer: bool = false) -> void:
	var playerPos: Vector2 = m_nRoom.get_player_pos()
	var roomSize: Vector2 = m_nRoom.get_room_size()
	var _x = playerPos.x
	var _y: int
	if _sameSideAsPlayer:
		_y = roomSize.y - 1 if (playerPos.y + 1) > roomSize.y / 2 else 0
	else:
		_y = 0 if (playerPos.y + 1) > roomSize.y / 2 else roomSize.y - 1
	set_board_pos(Vector2(_x, _y))

func _set_pos_behind_player() -> void:
	var playerPos: Vector2 = m_nRoom.get_player_pos()
	var _x = playerPos.x
	var _y: int
	if playerPos.y > 0 and m_nRoom.m_nPlayer.m_bIsFacingRight:
		_y = playerPos.y - 1
	elif playerPos.y < m_nRoom.get_room_size().y and !m_nRoom.m_nPlayer.m_bIsFacingRight:
		_y = playerPos.y + 1
	else:
		assert(false)
	set_board_pos(Vector2(_x, _y))
