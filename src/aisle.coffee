ame.ns 'ame.aisle', (ns) ->
	tileTypes =
		any: 'any'
		empty: 'empty'
		wall: 'wall'

	typeMatches = (type, tileInQuestion) ->
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
					@matchTiles[x].push tileTypes.any
			@resultTiles = (tileTypes.empty for i in [0...aisleHeight])

		matches: (tileSet) ->
			for x in [0...patternWidth]
				for y in [0...patternHeight]
					return false unless typeMatches @matchTiles[x][y], tileSet[x][y].type
			return true
	patterns = []

	regularFloorPattern = new ns.Pattern
	regularFloorPattern.resultTiles = ((if i < aisleHeight-1 then tileTypes.empty else tileTypes.wall) for i in [0...aisleHeight])
	patterns.push regularFloorPattern

	pattern = new ns.Pattern
	pattern.resultTiles = ((if i is aisleHeight-1 or i is aisleHeight-3 then tileTypes.wall else tileTypes.empty) for i in [0...aisleHeight])
	pattern.matchTiles[1][aisleHeight-3] = tileTypes.empty
	patterns.push pattern

	class ns.Aisle
		constructor: ->
			@tiles = []
			for i in [0...3]
				@addColumn regularFloorPattern.resultTiles

			for i in [0...10]
				@addNextColumn()

		addNextColumn: ->
			columnsToMatch = []
			columnsToMatch.push @tiles[x] for x in [(@tiles.length - 3)...(@tiles.length)]
			matchingPatterns = (pattern for pattern in patterns when pattern.matches columnsToMatch)
			console.log "whoa no matching pattern" if matchingPatterns.length is 0
			aMatchingPattern = matchingPatterns[Math.floor(Math.random() * matchingPatterns.length)]
			@addColumn aMatchingPattern.resultTiles

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
