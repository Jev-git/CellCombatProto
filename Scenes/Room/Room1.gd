extends Room

func _init():
	m_aBoardLayout = [
		[0, 0, 0, 0, 0, 0],
		[0, 2, 2, 2, 2, 2],
		[0, 2, 2, 2, 2, 2],
		[0, 0, 0, 0, 0, 0]
	]

func _process(delta):
	var pBg: ParallaxBackground = $ParallaxBackground
	var offset: Vector2 = pBg.get_scroll_offset()
	offset.x -= 2
	offset.y -= 2
	pBg.set_scroll_offset(offset)
