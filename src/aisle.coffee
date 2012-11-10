ame.ns 'ame.aisle', (ns) ->
	tileTypes =
		any: 'any'
		empty: 'empty'
		wall: 'wall'

	typeMatches: (type, tileInQuestion) ->
		return true if type is tileTypes.any
		return type is tileInQuestion

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
			@resultTiles = (tileTypes.empty for i in [0...aisleHeight])

		matches: (tileSet) ->
			for x in [0...patternWidth]
				for y in [0...patternHeight]
					return false if typeMatches tileSet[x][y].type, @matchTiles[x][y]
			return true
	patterns = []
	regularFloorPattern = new ns.Pattern
	regularFloorPattern.resultTiles = ((if i < aisleHeight-1 then tileTypes.empty else tileTypes.wall) for i in [0...aisleHeight])

	class ns.Aisle
		constructor: ->
			@tiles = []
			for i in [0...3]
				@addColumn regularFloorPattern.resultTiles

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
