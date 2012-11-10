ame.ns 'ame.aisle', (ns) ->
	tileTypes =
		any: 'any'
		empty: 'empty'
		wall: 'wall'

	aisleHeight = 7
	
	patternWidth = 3
	patternHeight = aisleHeight
	class ns.Pattern
		constructor: ->
			@matchTiles = []
			for x in [0...patternWidth]
				@matchTiles.push []
				for y in [0...patternHeight]
					@matchTiles[x].push tileTypes.empty
	class ns.Aisle
		constructor: ->
			@tiles = []

			@addColumn ((if i < aisleHeight-1 then tileTypes.empty else tileTypes.wall) for i in [0...aisleHeight])

		addColumn: (tileTypes) ->
			column = []
			x = @tiles.length
			for y in [0...aisleHeight]
				column.push {x:x, y:y, type:tileTypes[y]}
			@tiles.push column

		update: (delta) ->

		draw: (gfx) ->
			for column in @tiles
				@drawTile gfx, tile for tile in column

		drawTile: (gfx, tile) ->
			tileWidth = gfx.height / aisleHeight
			gfx.drawRectangle tile.x * tileWidth,
				tile.y * tileWidth,
				tileWidth,
				tileWidth, @tileColor(tile.type)

		tileColor: (tileType) ->
			switch tileType
				when tileTypes.empty then ame.gfx.colors.GREY
				when tileTypes.wall then ame.gfx.colors.BLACK
