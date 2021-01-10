extends Node2D
class_name Room

# Override these value in the _init() function of child rooms
# ==========================================
var tilesType: Array = [
	[-1, 0, 1, 2, 3, 0],
	[0, 2, 2, 3, 3, 0],
	[0, 2, 2, 3, 3, 0],
	[0, 0, 0, 0, 0, 0]
]
var playerInitPos: Vector2 = Vector2(1, 1)
# ==========================================

onready var board = $Board
onready var player: Player = $Player

func _ready():
	for i_row in range(board.get_child_count()):
		var row = board.get_child(i_row)
		for i_col in range(row.get_child_count()):
			var tile: Tile = row.get_child(i_col)
			tile.type = tilesType[i_row][i_col]
	
	player.set_player_pos(playerInitPos)
	$Chest.set_parent_tile(get_tile(Vector2(2, 2)))

func get_tile(tilePos: Vector2) -> Tile:
	if tilePos.x < 0 or tilePos.x > tilesType.size() or tilePos.y < 0 or tilePos.y > tilesType[0].size():
		return null
	return board.get_child(tilePos.x).get_child(tilePos.y)
