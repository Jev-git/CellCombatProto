extends Room
class_name FirstRoom

func _init():
	tilesType = [
		[0, 0, 0, 0, 0, -1],
		[0, 2, 2, 2, 2, 2],
		[0, 2, 2, 2, 2, 2],
		[0, 0, 0, 0, 0, -1]
	]
	playerInitPos = Vector2(1, 1)
