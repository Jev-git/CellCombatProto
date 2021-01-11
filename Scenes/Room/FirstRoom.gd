extends Room
class_name FirstRoom

func _init():
	boardLayout = [
		[0, 0, 0, 0, 0, -1],
		[0, 2, 2, 2, 2, 2],
		[0, 2, 2, 2, 2, 2],
		[0, 0, 0, 0, 0, -1]
	]
	
	unitsInitPos = [
		Vector2(1, 2), # Player
		Vector2(2, 3), # Chest
	]
