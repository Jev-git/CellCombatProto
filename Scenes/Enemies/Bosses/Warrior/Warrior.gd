extends Unit
class_name BossWarrior

enum STATE {IDLE, DECIDING, ATTACKING}

const m_nRangeProjectile: PackedScene = preload("Warrior Range Projectile.tscn")
const m_nPsychicBackground: PackedScene = preload("Warrior Psychic Background.tscn")

export var m_fJumpDownSpeed: float = 500.0

onready var m_nAnimP: AnimationPlayer = $AnimationPlayer
onready var m_nRandomAttackTimer: Timer = $RandomAttackTimer
onready var m_bIsPerformingJumpAttack: bool = false
onready var m_iState: int = STATE.IDLE

func _init():
	m_iUnitType = UNIT_TYPE.ENEMY
	m_bCanShareTile = false

func _ready():
	m_nAnimP.play("Idle")
	m_bIsFacingRight = false
	m_nRandomAttackTimer.connect("timeout", self, "_decide_random_attack")

func _decide_random_attack():
	randomize()
	match randi() % 4:
		0:
			_do_slash_attack()
		1:
			_do_range_attack_sequence()
		2:
			_do_psychic_attack()
		3:
			_do_jump_attack()
	m_iState = STATE.ATTACKING

func _process(delta):
	match m_iState:
		STATE.IDLE:
			m_iState = STATE.DECIDING
			m_nRandomAttackTimer.start()
		STATE.DECIDING:
			return
		STATE.ATTACKING:
			if m_bIsPerformingJumpAttack:
				_process_jump_attack(delta)

func _process_jump_attack(delta):
	m_nAnimP.play("Fall")
	global_position.y += m_fJumpDownSpeed * delta
	var _oldBoardPos: Vector2 = m_nRoom.get_tile(m_vBoardPos).global_position
	if global_position.y > _oldBoardPos.y:
		global_position.y = _oldBoardPos.y
		m_bIsPerformingJumpAttack = false
		m_bCanShareTile = false
		m_nAnimP.play("Idle")
		# Deal damage on landing
		m_nRoom.deal_damage_to_tile(m_vBoardPos)
		m_nRoom.deal_damage_to_tile(Vector2(m_vBoardPos.x + 1, m_vBoardPos.y))
		m_nRoom.deal_damage_to_tile(Vector2(m_vBoardPos.x - 1, m_vBoardPos.y))
		m_nRoom.deal_damage_to_tile(Vector2(m_vBoardPos.x, m_vBoardPos.y + 1))
		m_nRoom.deal_damage_to_tile(Vector2(m_vBoardPos.x, m_vBoardPos.y - 1))
		m_iState = STATE.IDLE

func _receive_damage() -> void:
	pass
#	print("Warrior received damage")

func _set_pos_for_range_attack() -> void:
	var roomSize: Vector2 = m_nRoom.get_room_size()
	randomize()
	var _x: int = (1 if randf() <= 0.5 else 2)
	var _y: int = (0 if randf() <= 0.5 else roomSize.y - 1)
	set_board_pos(Vector2(_x, _y))
	_set_facing_to_player()

func _do_slash_attack():
	_set_pos_behind_player()
	_set_facing_to_player()
	m_nAnimP.play("Attack3")
	yield(get_tree().create_timer(0.6), "timeout")
	var aheadPos = Vector2(m_vBoardPos.x, m_vBoardPos.y + (1 if m_bIsFacingRight else -1))
	m_nRoom.deal_damage_to_tile(aheadPos)
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Idle")
	m_iState = STATE.IDLE

func _do_range_attack_sequence(_attackLeft: int = 4) -> void:
	yield(get_tree().create_timer(randf() * 0.5), "timeout")
	_set_pos_for_range_attack()
	m_nAnimP.play("Attack1")
	yield(get_tree().create_timer(0.9), "timeout")
	var projectile: EnemyProjectile_WarriorRangeProjectile = m_nRangeProjectile.instance()
	var _x = m_vBoardPos.x
	var _y = m_vBoardPos.y + (1 if m_bIsFacingRight else -1)
	m_nRoom.add_unit(projectile)
	projectile.init(Vector2(_x, _y), m_vBoardPos.y < m_nRoom.get_player_pos().y)
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Idle")
	if _attackLeft > 1:
		_do_range_attack_sequence(_attackLeft - 1)
	else:
		m_iState = STATE.IDLE

func _do_psychic_attack() -> void:
	_set_facing_to_player()
	m_nAnimP.play("Psychic")
	yield(get_tree().create_timer(0.7), "timeout")
	var psychicBackground = m_nPsychicBackground.instance()
	add_child(psychicBackground)
	yield(get_tree().create_timer(1.0), "timeout")
	m_nRoom.play_fx("Shockwave")
	
	# If player is facing the Warrior, they will get stunned
	var player: Player = m_nRoom.m_nPlayer
	if (player.m_bIsFacingRight and player.m_vBoardPos.y < m_vBoardPos.y) \
	or (!player.m_bIsFacingRight and player.m_vBoardPos.y > m_vBoardPos.y):
		player.get_stunned()
	
	yield(get_tree().create_timer(0.3), "timeout")
	m_nAnimP.play("Idle")
	m_iState = STATE.IDLE

func _do_jump_attack():
	m_bIsPerformingJumpAttack = true
	m_bCanShareTile = true
	
	# Position the boss directly on top of the player
	set_board_pos(m_nRoom.get_player_pos())
	global_position.y = m_nRoom.get_node("UpperBoundPosition").global_position.y
	
	# Flash tiles that will take damage
	var _tile: Tile
	_tile = m_nRoom.get_tile(m_vBoardPos)
	_tile.flash()
	_tile = m_nRoom.get_tile(Vector2(m_vBoardPos.x + 1, m_vBoardPos.y))
	if _tile: _tile.flash()
	_tile = m_nRoom.get_tile(Vector2(m_vBoardPos.x - 1, m_vBoardPos.y))
	if _tile: _tile.flash()
	_tile = m_nRoom.get_tile(Vector2(m_vBoardPos.x, m_vBoardPos.y + 1))
	if _tile: _tile.flash()
	_tile = m_nRoom.get_tile(Vector2(m_vBoardPos.x, m_vBoardPos.y - 1))
	if _tile: _tile.flash()
