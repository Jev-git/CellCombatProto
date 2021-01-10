extends Node2D

onready var animS: AnimatedSprite = $AnimatedSprite

func _ready():
	animS.play("Default")

func set_parent_tile(parentTile: Tile) -> void:
	parentTile.connect("take_dmg", self, "_open_chest")
	global_position = parentTile.global_position

func _open_chest() -> void:
	animS.play("Open")

