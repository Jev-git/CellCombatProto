extends Unit
class_name BossWarrior

enum JUMP_ATTACK_PHASE {NONE, JUMPING, WAITING, FALLING}

const m_nRangeProjectile: PackedScene = preload("Warrior Range Projectile.tscn")

export var m_fJumpSpeed: float = 500.0

onready var m_nAnimP: AnimationPlayer = $AnimationPlayer
onready var m_nJumpAtkTimer: Timer = $JumpAttackWaitTimer
onready var m_iJumpAttackPhase: int = JUMP_ATTACK_PHASE.NONE

func _init():
	m_iUnitType = UNIT_TYPE.ENEMY
	m_bCanShareTile = false

func _ready():
	m_nAnimP.play("Idle")
	m_nJumpAtkTimer.connect("timeout", self, "_start_falling_down")
#	_do_jump_attack()
	_do_range_attack_sequence()

func _process(delta):
	_process_jump_attack(delta)

func _process_jump_attack(delta):
	match m_iJumpAttackPhase:
		JUMP_ATTACK_PHASE.NONE:
			return
		JUMP_ATTACK_PHASE.JUMPING:
			m_nAnimP.play("Jump")
			m_bCanShareTile = true
			global_position.y -= m_fJumpSpeed * delta
			if global_position.y < m_nRoom.get_node("UpperBoundPosition").global_position.y:
				m_nJumpAtkTimer.start(randf() * 3.0)
				m_iJumpAttackPhase = JUMP_ATTACK_PHASE.WAITING
		JUMP_ATTACK_PHASE.WAITING:
			return
		JUMP_ATTACK_PHASE.FALLING:
			m_nAnimP.play("Fall")
			global_position.y += m_fJumpSpeed * delta
			var _oldBoardPos: Vector2 = m_nRoom.get_tile(m_vBoardPos).global_position
			if global_position.y > _oldBoardPos.y:
				m_iJumpAttackPhase = JUMP_ATTACK_PHASE.NONE
				global_position.y = _oldBoardPos.y
				m_bCanShareTile = false
				_do_damage_to_tile_on_landing()
				m_nAnimP.play("Idle")

func _start_falling_down():
	var _y = global_position.y
	_set_pos_behind_player()
	_set_facing_to_player()
	global_position.y = _y
	_flash_tiles_when_falling()
	m_iJumpAttackPhase = JUMP_ATTACK_PHASE.FALLING

func _do_jump_attack():
	yield(get_tree().create_timer(randf() * 3.0), "timeout")
	m_iJumpAttackPhase = JUMP_ATTACK_PHASE.JUMPING

func _flash_tiles_when_falling():
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

func _do_damage_to_tile_on_landing():
	m_nRoom.deal_damage_to_tile(m_vBoardPos)
	m_nRoom.deal_damage_to_tile(Vector2(m_vBoardPos.x + 1, m_vBoardPos.y))
	m_nRoom.deal_damage_to_tile(Vector2(m_vBoardPos.x - 1, m_vBoardPos.y))
	m_nRoom.deal_damage_to_tile(Vector2(m_vBoardPos.x, m_vBoardPos.y + 1))
	m_nRoom.deal_damage_to_tile(Vector2(m_vBoardPos.x, m_vBoardPos.y - 1))

func _test_attack():
	yield(get_tree().create_timer(randf() * 3.0), "timeout")
	_set_pos_align_with_player(true)
	_set_facing_to_player()
	m_nAnimP.play("Attack3")
	yield(get_tree().create_timer(0.3), "timeout")
	var aheadPos = Vector2(m_vBoardPos.x, m_vBoardPos.y + (1 if m_bIsFacingRight else -1))
	m_nRoom.deal_damage_to_tile(aheadPos)
	yield(m_nAnimP, "animation_finished")
	m_nAnimP.play("Idle")
	_test_attack()

func _receive_damage() -> void:
	print("Warrior received damage")

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

func _set_pos_for_range_attack() -> void:
	var roomSize: Vector2 = m_nRoom.get_room_size()
	var _x: int = 1 if randf() <= 0.5 else 2
	var _y: int = 0 if randf() <= 0.5 else roomSize.y - 1
	set_board_pos(Vector2(_x, _y))
	_set_facing_to_player()

func _do_mental_attack() -> void:
	pass
