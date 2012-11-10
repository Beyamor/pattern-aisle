ame.ns 'ame.input', (ns) ->

	mouseDown = false
	mousePos = new ame.math.Vec2
	keymap = {}
	keystate = []

	defineVk = (code, name) ->
		keymap['vk_' + name] = code

	# letters
	for code in [65..90]
		name = String.fromCharCode(code).toLowerCase()
		defineVk code, name

	# numbers
	for code in [48..57]
		name = String.fromCharCode code
		defineVk code, name

	# arrow keys
	defineVk 37, 'left'
	defineVk 38, 'up'
	defineVk 39, 'right'
	defineVk 40, 'down'

	# space
	defineVk 32, 'space'

	ns.focusOnEl = (el) ->
		window.addEventListener 'keydown', (e) ->
			keystate[e.keyCode] = 'down'
		, true

		window.addEventListener 'keyup', (e) ->
			keystate[e.keyCode] = 'up'
		, true

		window.onmousedown = (e) -> mouseDown = true
		window.onmouseup = (e) -> mouseDown = false

		$(el).mousemove (e) ->
			mousePos.x = e.pageX - this.offsetLeft
			mousePos.y = e.pageY - this.offsetTop
	
	ns.define = (mapping, definitions...) ->
		keymap[mapping] = definitions

	ns.isDown = (key) ->
		value = keymap[key]

		if typeof value is 'number'
			return keystate[value] is 'down'

		else if value instanceof Array
			for binding in value
				if ns.isDown binding
					return true
			return false

		return false

	ns.isUp = (key) ->
		not ns.isDown key

	ns.isMouseDown = -> mouseDown
	ns.isMouseUp = -> not ns.isMouseDown()

	ns.getMousePos = -> mousePos

	ns.definition = (mapping) ->
		definition for definition of keymap when keymap[definition] is mapping
