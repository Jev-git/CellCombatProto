extends Node2D
class_name Player

onready var room = get_parent()
onready var animS: AnimatedSprite = $AnimatedSprite

onready var boardPos: Vector2
onready var acceptingInput: bool = true
onready var facingRight: bool = true

func _ready():
	animS.connect("animation_finished", self, "_on_anim_finished")

func _process(delta):
	handle_input()

func _on_anim_finished() -> void:
	if !acceptingInput:
		if animS.get_animation() in ["Attack", "Special"]:
			acceptingInput = true

func handle_input() -> void:
	if !acceptingInput: return
	
	# In Stance
	if Input.is_action_pressed("ui_stance"):
		# Special attack
		if Input.is_action_just_pressed("ui_attack"):
			animS.play("Special")
			_deal_dmg_to_tile("Special")
			acceptingInput = false
		elif Input.is_action_just_pressed("ui_right"):
			if facingRight: # Dash
				pass
			else: # Turn
				set_facing_direction(true)
		elif Input.is_action_just_pressed("ui_left"):
			if !facingRight: # Dash
				pass
			else: # Turn
				set_facing_direction(false)
		else:
			animS.play("Stance")
		return
	
	# Attack
	if Input.is_action_just_pressed("ui_attack"):
		animS.play("Attack")
		_deal_dmg_to_tile("Attack")
		acceptingInput = false
		return
	
	# Movement
	if Input.is_action_just_pressed("ui_right"):
		set_player_pos(Vector2(boardPos.x, boardPos.y + 1))
	elif Input.is_action_just_pressed("ui_left"):
		set_player_pos(Vector2(boardPos.x, boardPos.y - 1))
	elif Input.is_action_just_pressed("ui_up"):
		set_player_pos(Vector2(boardPos.x - 1, boardPos.y))
	elif Input.is_action_just_pressed("ui_down"):
		set_player_pos(Vector2(boardPos.x + 1, boardPos.y))
	animS.play("Default")

func set_player_pos(_boardPos: Vector2) -> void:
	var targetTile: Tile = room.get_tile(_boardPos)
	if targetTile:
		if targetTile.type in [Tile.TILE_TYPE.PLAYER, Tile.TILE_TYPE.COMMON]:
			self.global_position = targetTile.global_position
			boardPos = _boardPos

func set_facing_direction(_facingRight: bool) -> void:
	animS.flip_h = !_facingRight
	facingRight = _facingRight

func _deal_dmg_to_tile(_animName: String) -> void:
	match _animName:
		"Attack":
			var aheadPos = Vector2(boardPos.x, boardPos.y + (1 if facingRight else -1))
			var aheadTile = room.get_tile(aheadPos)
			if aheadTile:
				aheadTile.take_dmg(Tile.TILE_TYPE.PLAYER)
		"Special":
			var aheadPos = Vector2(boardPos.x, boardPos.y + (1 if facingRight else -1))
			var aheadTile = room.get_tile(aheadPos)
			if aheadTile:
				aheadTile.take_dmg(Tile.TILE_TYPE.PLAYER)
			aheadPos = Vector2(boardPos.x, boardPos.y + (2 if facingRight else -2))
			aheadTile = room.get_tile(aheadPos)
			if aheadTile:
				aheadTile.take_dmg(Tile.TILE_TYPE.PLAYER)
