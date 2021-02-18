extends Node2D
class_name Room

# Override these values in the _init() function of child rooms
# ==========================================
var m_aBoardLayout: Array
var m_vRoomSize: Vector2
# ==========================================

onready var m_nBoard = $Board
onready var m_nUnits = $Units
onready var m_nPlayer: Player

onready var m_nAnimP: AnimationPlayer = $AnimationPlayer

signal tile_damaged

func _ready():
	m_vRoomSize = Vector2(m_aBoardLayout.size(), m_aBoardLayout[0].size())
	
	# Set up tiles from boardLayout
	for i_row in range(m_vRoomSize.x):
		var row = m_nBoard.get_child(i_row)
		for i_col in range(m_vRoomSize.y):
			var tile: Tile = row.get_child(i_col)
			tile.type = m_aBoardLayout[i_row][i_col]
	
	# Set up units initial board position
	for unit in m_nUnits.get_children():
		unit.set_board_pos(unit.INIT_BOARD_POS)
		connect("tile_damaged", unit, "_on_tile_damaged")
	
	# Get Player node
	m_nPlayer = get_tree().get_nodes_in_group("Player")[0]

func get_tile(tilePos: Vector2) -> Tile:
	if tilePos.x < 0 or tilePos.x > m_vRoomSize.x - 1 or tilePos.y < 0 or tilePos.y > m_vRoomSize.y - 1:
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
		for unit in m_nUnits.get_children():
			if !unit.m_bCanShareTile and unit.m_vBoardPos == tilePos:
				return false
		return true

func get_player_pos() -> Vector2:
	return m_nPlayer.m_vBoardPos

func get_room_size() -> Vector2:
	return m_vRoomSize

func add_unit(_unit: Unit) -> void:
	_unit.m_nRoom = self
	m_nUnits.add_child(_unit)
	connect("tile_damaged", _unit, "_on_tile_damaged")

func play_fx(_fxName: String) -> void:
	m_nAnimP.play(_fxName)
