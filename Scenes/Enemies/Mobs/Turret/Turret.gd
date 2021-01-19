extends Unit
class_name Turret

onready var animP: AnimationPlayer = $AnimationPlayer

func _ready():
	animP.play("Raise")
