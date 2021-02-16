extends Node2D

onready var m_nAnimP: AnimationPlayer = $AnimationPlayer

func _ready():
	m_nAnimP.play("Default")
	yield(m_nAnimP, "animation_finished")
	print("finished")
#	queue_free()
