extends Unit
class_name Player

onready var m_nAnimS: AnimatedSprite = $AnimatedSprite
onready var m_nAnimP: AnimationPlayer = $AnimationPlayer
onready var m_nChargeAttackTimer: Timer = $ChargeAttackTimer

onready var m_bAcceptingInput: bool = true
onready var m_bIsAttackCharging: bool = false
onready var m_bIsAttackCharged: bool = false

func _init():
	m_iUnitType = UNIT_TYPE.PLAYER
	m_bCanShareTile = false

func _ready():
	m_nAnimS.connect("animation_finished", self, "_on_anim_finished")
	m_nChargeAttackTimer.connect("timeout", self, "_on_stance_timer_timeout")

func _process(delta):
	_handle_input()

func _on_anim_finished() -> void:
	if !m_bAcceptingInput:
		if m_nAnimS.get_animation() in ["Attack", "Special"]:
			m_bAcceptingInput = true

func _handle_input() -> void:
	if !m_bAcceptingInput: return
	
	# Turn around
	if Input.is_action_just_pressed("ui_turn"):
		_set_facing_right(!m_bIsFacingRight)
	
	# Attack
	if Input.is_action_just_pressed("ui_attack"):
		_play_anim_and_deal_damage("Attack")
		return
	
	# Charge attack (charging)
	if Input.is_action_pressed("ui_attack"):
		if !m_bIsAttackCharging and !m_bIsAttackCharged: # Start charging
			m_bIsAttackCharging = true
			m_nChargeAttackTimer.start()
			m_nAnimS.play("Charge")
			m_nAnimP.play("Charge")
		return
	
	# Charge attack
	if Input.is_action_just_released("ui_attack"):
		if m_bIsAttackCharged:
			m_bIsAttackCharged = false
			_play_anim_and_deal_damage("Special")
			return
		m_bIsAttackCharging = false
		m_nAnimP.play("Default")
		m_nChargeAttackTimer.stop()
	
	# Movement
	if Input.is_action_just_pressed("ui_right"):
		set_board_pos(Vector2(m_vBoardPos.x, m_vBoardPos.y + 1))
	elif Input.is_action_just_pressed("ui_left"):
		set_board_pos(Vector2(m_vBoardPos.x, m_vBoardPos.y - 1))
	elif Input.is_action_just_pressed("ui_up"):
		set_board_pos(Vector2(m_vBoardPos.x - 1, m_vBoardPos.y))
	elif Input.is_action_just_pressed("ui_down"):
		set_board_pos(Vector2(m_vBoardPos.x + 1, m_vBoardPos.y))
	m_nAnimS.play("Default")

func _play_anim_and_deal_damage(_animName: String) -> void:
	m_nAnimS.play(_animName)
	m_bAcceptingInput = false
	
	match _animName:
		"Attack":
			var aheadPos = Vector2(m_vBoardPos.x, m_vBoardPos.y + (1 if m_bIsFacingRight else -1))
			m_nRoom.deal_damage_to_tile(aheadPos, true)
		"Special":
			m_nAnimP.play("Default")
			var aheadPos = Vector2(m_vBoardPos.x, m_vBoardPos.y + (1 if m_bIsFacingRight else -1))
			m_nRoom.deal_damage_to_tile(aheadPos, true)
			aheadPos = Vector2(m_vBoardPos.x, m_vBoardPos.y + (2 if m_bIsFacingRight else -2))
			m_nRoom.deal_damage_to_tile(aheadPos, true)

func _receive_damage() -> void:
	print("Player received damage")

func _on_stance_timer_timeout():
	m_bIsAttackCharged = true
	m_bIsAttackCharging = false
