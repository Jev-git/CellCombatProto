extends Node2D
class_name Room

# Override these values in the _init() function of child rooms
# ==========================================
onready var m_aBoardLayout: Array
# ==========================================

onready var m_nBoard = $Board
onready var n_nUnits = $Units

signal unit_moved
signal tile_damaged

func _ready():
	# Set up tiles from boardLayout
	for i_row in range(m_nBoard.get_child_count()):
		var row = m_nBoard.get_child(i_row)
		for i_col in range(row.get_child_count()):
			var tile: Tile = row.get_child(i_col)
			tile.type = m_aBoardLayout[i_row][i_col]
	
	# Set up units initial board position
	for unit in n_nUnits.get_children():
		unit.set_board_pos(unit.initBoardPos)
		connect("tile_damaged", unit, "_on_tile_damaged")

func get_tile(tilePos: Vector2) -> Tile:
	if tilePos.x < 0 or tilePos.x > m_aBoardLayout.size() or tilePos.y < 0 or tilePos.y > m_aBoardLayout[0].size():
		return null
	return m_nBoard.get_child(tilePos.x).get_child(tilePos.y)

func deal_damage_to_tile(tilePos: Vector2, isPlayerDmg: bool = false) -> void:
	var tile: Tile = get_tile(tilePos)
	if tile:
		tile.flash(isPlayerDmg)
		emit_signal("tile_damaged", tilePos, isPlayerDmg)

func is_tile_empty(tilePos: Vector2) -> bool:
	var tile: Tile = get_tile(tilePos)
	if !tile:
		return false
	else:
		for unit in n_nUnits.get_children():
			if !unit.canShareTile and unit.boardPos == tilePos:
				return false
		return true
