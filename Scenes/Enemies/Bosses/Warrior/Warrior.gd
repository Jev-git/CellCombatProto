extends Unit
class_name BossWarrior

onready var m_nAnimP: AnimationPlayer = $AnimationPlayer

func _init():
	m_iUnitType = UNIT_TYPE.ENEMY
	m_bCanShareTile = false

func _ready():
	m_nAnimP.play("Idle")
	_test_attack()

func _test_attack():
	yield(get_tree().create_timer(randf() * 3.0), "timeout")
	_set_pos_align_with_player(true)
	_set_facing_to_player()
	_play_anim_and_deal_damage("Attack3")
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Idle")
	_test_attack()

func _play_anim_and_deal_damage(_animName: String) -> void:
	m_nAnimP.play(_animName)
	match _animName:
		"Attack3":
			yield(get_tree().create_timer(0.3), "timeout")
			var aheadPos = Vector2(m_vBoardPos.x, m_vBoardPos.y + (1 if m_bIsFacingRight else -1))
			m_nRoom.deal_damage_to_tile(aheadPos)

func _receive_damage() -> void:
	print("Warrior received damage")
