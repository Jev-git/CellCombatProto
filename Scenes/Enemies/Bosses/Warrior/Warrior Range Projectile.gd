extends Unit
class_name EnemyProjectile_WarriorRangeProjectile

const MOVE_INTERVAL: float = 0.2

onready var m_bIsStarted: bool = false
onready var m_fIntervalLeft: float = MOVE_INTERVAL

func _init():
	m_iUnitType = UNIT_TYPE.ENEMY_PROJECTILE
	m_bCanShareTile = true

func _process(delta):
	if m_bIsStarted:
		print(delta)
		m_fIntervalLeft -= delta
		if m_fIntervalLeft <= 0:
			m_fIntervalLeft += MOVE_INTERVAL
			var _x = m_vBoardPos.x
			var _y = m_vBoardPos.y + (1 if m_bIsFacingRight else -1)
			set_board_pos(Vector2(_x, _y))

func init(_mBoardPos: Vector2) -> void:
	m_vBoardPos = _mBoardPos
	set_board_pos(m_vBoardPos)
	_set_facing_to_player()
	m_bIsStarted = true
