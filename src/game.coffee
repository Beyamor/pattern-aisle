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

	aThing = null

	$controlPanel = $('<div></div>')
	$('body').append $controlPanel
	$changeDeal = $('<button id="changeState"></button>')
	$controlPanel.append $changeDeal
	openEditor = (e) ->
		aThing = new ame.aisle.Editor $canvas
		$changeDeal.html 'Close editor'
		$changeDeal.click closeEditor
		$('#restartLevel', $controlPanel).remove()
	closeEditor = (e) ->
		aThing = new ame.aisle.Aisle
		$changeDeal.html 'Open editor'
		$changeDeal.click openEditor
		$restartLevel = $('<button id="restartLevel">Restart level</button>')
		$controlPanel.append $restartLevel
		$restartLevel.click (e) ->
			aThing = new ame.aisle.Aisle
	closeEditor()

	setInterval ->
		currentTime = new Date()
		delta = (currentTime - previousTime) * 0.001

		aThing.update delta

		gfx.clear()
		aThing.draw gfx

		previousTime = new Date()

	, 1000.0 / FPS

	gfx.clear()
