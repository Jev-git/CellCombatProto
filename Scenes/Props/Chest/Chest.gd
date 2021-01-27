extends Unit
class_name Chest

onready var animS: AnimatedSprite = $AnimatedSprite

func _init():
	m_iUnitType = UNIT_TYPE.PROP
	m_bCanShareTile = false

func _ready():
	animS.play("Default")

func _open_chest() -> void:
	animS.play("Open")

func _on_tile_damaged(tilePos: Vector2, isPlayerDmg: bool) -> void:
	if tilePos == m_vBoardPos and isPlayerDmg:
		_open_chest()
