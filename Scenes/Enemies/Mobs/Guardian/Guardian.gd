extends Unit
class_name EnemyGuardian

onready var m_nAnimP: AnimationPlayer = $AnimationPlayer

func _init():
	m_iUnitType = UNIT_TYPE.ENEMY
	m_bCanShareTile = false

func _ready():
	m_nAnimP.play("Hidden")
	yield(get_tree().create_timer(1.0), "timeout")
	m_nAnimP.play("Appear")
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Idle")
	yield(get_tree().create_timer(randf() * 3.0), "timeout")
	m_nAnimP.play("Disappear")
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Hidden")
	_test_attack()

func _set_facing_to_player():
	var playerPos: Vector2 = m_nRoom.get_player_pos()
	_set_facing_right(!(playerPos.y < m_vBoardPos.y))

func _set_pos_align_with_player():
	var playerPos: Vector2 = m_nRoom.get_player_pos()
	var roomSize: Vector2 = m_nRoom.get_room_size()
	var _x = playerPos.x
	var _y = 0 if (playerPos.y + 1) > roomSize.y / 2 else roomSize.y - 1
	set_board_pos(Vector2(_x, _y))

func _test_attack():
	yield(get_tree().create_timer(randf() * 3.0), "timeout")
	_set_pos_align_with_player()
	_set_facing_to_player()
	m_nAnimP.play("Appear")
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Preparing")
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Attack")
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Idle")
	yield(get_tree().create_timer(randf() * 3.0), "timeout")
	m_nAnimP.play("Disappear")
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Hidden")
	_test_attack()
