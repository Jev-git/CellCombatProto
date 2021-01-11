extends Node2D
class_name Chest

onready var room = get_parent().get_parent()
onready var animS: AnimatedSprite = $AnimatedSprite
onready var boardPos: Vector2

func _ready():
	animS.play("Default")

func _open_chest() -> void:
	animS.play("Open")

func set_board_pos(_boardPos: Vector2):
	var parentTile: Tile = room.get_tile(_boardPos)
	if parentTile:
		boardPos = _boardPos
		global_position = parentTile.global_position

func _on_tile_damaged(tilePos: Vector2, isPlayerDmg: bool) -> void:
	if tilePos == boardPos and isPlayerDmg:
		_open_chest()
