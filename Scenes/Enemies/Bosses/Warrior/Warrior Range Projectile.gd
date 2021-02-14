extends Unit
class_name EnemyProjectile_WarriorRangeProjectile

const MOVE_INTERVAL: float = 0.1

onready var m_bIsStarted: bool = false
onready var m_fIntervalLeft: float = MOVE_INTERVAL

func _init():
	m_iUnitType = UNIT_TYPE.ENEMY_PROJECTILE
	m_bCanShareTile = true

func _process(delta):
	if m_bIsStarted:
		var playerPos = m_nRoom.get_player_pos()
		if playerPos == m_vBoardPos:
			queue_free()
		else:
			m_fIntervalLeft -= delta
			if m_fIntervalLeft <= 0:
				m_fIntervalLeft += MOVE_INTERVAL
				var _x = m_vBoardPos.x
				var _y = m_vBoardPos.y + (1 if m_bIsFacingRight else -1)
				if _y < 0 or _y >= m_nRoom.get_room_size().y:
					queue_free()
				else:
					set_board_pos(Vector2(_x, _y))
					m_nRoom.deal_damage_to_tile(Vector2(_x, _y))

func init(_mBoardPos: Vector2, _facingRight: bool) -> void:
	m_vBoardPos = _mBoardPos
	m_bIsFacingRight = _facingRight
	set_board_pos(m_vBoardPos)
	_set_facing_right(m_bIsFacingRight)
	m_nRoom.deal_damage_to_tile(m_vBoardPos)
	m_bIsStarted = true
