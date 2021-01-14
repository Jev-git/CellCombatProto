extends Unit
class_name Chest

onready var animS: AnimatedSprite = $AnimatedSprite

func _init():
	unitType = UNIT_TYPE.PROP
	canShareTile = false

func _ready():
	animS.play("Default")

func _open_chest() -> void:
	animS.play("Open")

func _on_tile_damaged(tilePos: Vector2, isPlayerDmg: bool) -> void:
	if tilePos == boardPos and isPlayerDmg:
		_open_chest()
