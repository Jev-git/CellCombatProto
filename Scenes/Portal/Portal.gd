extends Unit
class_name Portal

const ROOM_SCENE_DIR: String = "res://Scenes/Room/"
export var nextRoom: String

onready var animP: AnimationPlayer = $AnimationPlayer

func _init():
	unitType = UNIT_TYPE.PORTAL
	canShareTile = true

func _ready():
	assert(nextRoom)
	animP.play("Default")
	room.connect("unit_moved", self, "_on_unit_moved")

func _on_unit_moved(_unitType: int, _boardPos: Vector2):
	if _unitType == UNIT_TYPE.PLAYER and _boardPos == self.boardPos:
		get_tree().change_scene(ROOM_SCENE_DIR + nextRoom + ".tscn")
