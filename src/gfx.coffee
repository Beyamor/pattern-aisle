ame.ns 'ame.gfx', (ns) ->
	colors =
		BLACK:	'#000000'
		WHITE:	'#FFFFFF'
		RED:	'#FF0000'
		BLUE:	'#357EC7'
		YELLOW:	'#FDD017'
		GREEN:	'#52D017'
		PINK:	'pink'
		GREY:	'#736F6E'
		PURPLE: '#8D38C9'

	ns.colors = colors

	##############################
	#	
	#	Images!
	#
	##############################

	images = {}

	ns.img = {}
	ns.img.allReady = ->
		allImagesReady = true
		for src, image of images
			allImagesReady &= image.isReady

		return $.isReady and allImagesReady
	
	ns.img.load = (src, onload=null) ->
		image = null

		if not images.src
			image = new Image()
			image.isReady = false
			image.onload = ->
				image.isReady = true
			image.src = src
			images[src] = image
		else
			image = images.src

		if onload
			if image.isReady
				onload()
			else
				oldOnload = image.onload
				image.onload = ->
					oldOnload image
					onload image

		return image

	##############################
	#	
	#	Sprites!
	#
	##############################
	
	sprites = {}

	ns.sprites = {}
	ns.sprites.names = []

	ns.sprites.define = (name, arg) ->
		args = null

		if typeof arg is 'string'
			args =
				source: arg
		else
			args = arg

		args.originX = 0 unless args.originX?
		args.originY = 0 unless args.originY?

		sprite =
			name: name
			originX: args.originX
			originY: args.originY

		sprite.data = ns.img.load args.source, (img) ->
			sprite.width = img.width unless sprite.width
			sprite.height = img.height unless sprite.height
			sprite.frameWidth = img.width unless sprite.frameWidth
			sprite.frameHeight = img.height unless sprite.frameHeight

		sprites[name] = sprite
		ns.sprites.names.push name
		return sprite

	ns.sprites.get = (name) ->
		sprites[name]

	##############################
	#	
	#	Actual graphics!
	#
	##############################

	class ns.GraphicsContext
		constructor: (canvas) ->
			@context = canvas.getContext '2d'
			@width = canvas.width
			@height = canvas.height
			@clearColor = colors.WHITE

		setAlpha: (alpha) ->
			@context.globalAlpha = alpha

		fillContext: (color) ->
			@context.fillStyle = color
			@context.fill()

		strokeContext: (color, lineWidth=2) -> # heh
			@context.lineWidth = lineWidth
			@context.strokeStyle = color
			@context.stroke()

		fillOrStroke: (color, fill) ->
			if fill
				@fillContext color
			else
				@strokeContext color
		
		drawRectangle: (x, y, width, height, color=colors.BLACK, alpha=1, filled=true) ->
			@setAlpha alpha
			if filled
				@context.fillStyle = color
				@context.fillRect x, y, width, height
			else
				@context.strokeStyle = color
				@context.strokeRect x, y, width, height

		drawArc: (x, y, radius, startAngle, endAngle, color=colors.BLACK, alpha=1, filled=true) ->
			# the arc coordinates are the stupidest thing ever
			startAngle = 2 * Math.PI - startAngle
			endAngle = 2 * Math.PI - endAngle
			@context.beginPath()
			@context.arc x, y, radius, startAngle, endAngle, true
			@setAlpha alpha
			if filled
				@context.fillStyle = color
				@context.fill()
			else
				@context.strokeStyle = color
				@context.stroke()

		drawCircle: (x, y, radius, color=colors.BLACK, alpha=1, filled=true) ->
			@drawArc x, y, radius, 0, 2 * Math.PI, color, alpha, filled

		drawImage: (img, x, y) ->
			@context.drawImage img, x, y

		clear: ->
			@drawRectangle 0, 0, @width, @height, @clearColor
