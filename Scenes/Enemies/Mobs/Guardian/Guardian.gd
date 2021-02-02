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
