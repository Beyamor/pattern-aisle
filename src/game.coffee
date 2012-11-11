$ ->
	FPS = 30

	input = ame.input
	states = ame.gamestates

	$canvas = $('canvas')
	$canvas.attr('tabindex', 1)

	scrollKeys = [33,34,35,36,37,38,39,40]
	$(document).keydown (e) ->
		key = e.which
		if $.inArray(key, scrollKeys) > -1 and $canvas.is(':focus')
			e.preventDefault()
			return false

	input.focusOnEl $canvas[0]
	input.define 'left', 'vk_a', 'vk_left'
	input.define 'right', 'vk_d', 'vk_right'

	gfx = new ame.gfx.GraphicsContext $canvas[0]

	currentTime = new Date()
	previousTime = currentTime

	aThing = new ame.aisle.Aisle
	#aThing = new ame.aisle.Editor $canvas

	setInterval ->
		currentTime = new Date()
		delta = (currentTime - previousTime) * 0.001

		aThing.update delta

		gfx.clear()
		aThing.draw gfx

		previousTime = new Date()

	, 1000.0 / FPS

	gfx.clear()
