extends Room

func _init():
	m_aBoardLayout = [
		[0, 0, 0, 0, 0, 0],
		[0, 2, 2, 2, 2, 0],
		[0, 2, 2, 2, 2, 0],
		[0, 0, 0, 0, 0, 0]
	]

func _process(delta):
	# Since there is currently no camera,
	# we move the parallax background manually
	var pBg: ParallaxBackground = $ParallaxBackground
	var offset: Vector2 = pBg.get_scroll_offset()
	pBg.set_scroll_offset(Vector2(offset.x - 2, offset.y - 0.5))
