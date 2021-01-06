extends Node2D
class_name Board

onready var tilesType: Array = [
	[0, 0, 0, 0, 0, 0],
	[0, 2, 2, 3, 3, 0],
	[0, 2, 2, 3, 3, 0],
	[0, 0, 0, 0, 0, 0]
]
onready var tiles = $Tiles
onready var player: Player = $Player

export var playerInitPos: Vector2

func _ready():
	for i_row in range(tiles.get_child_count()):
		var row = tiles.get_child(i_row)
		for i_col in range(row.get_child_count()):
			var tile: Tile = row.get_child(i_col)
			tile.tileType = tilesType[i_row][i_col]
	
	player.set_player_pos(playerInitPos)

func get_tile(tilePos: Vector2) -> Tile:
	if tilePos.x < 0 or tilePos.x > tilesType.size() or tilePos.y < 0 or tilePos.y > tilesType[0].size():
		return null
	return tiles.get_child(tilePos.x).get_child(tilePos.y)
