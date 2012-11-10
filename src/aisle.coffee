ame.ns 'ame.aisle', (ns) ->
	tileTypes =
		any: 'any'
		empty: 'empty'
		wall: 'wall'
	tileTypeList = (type for typeName, type of tileTypes)

	typeMatches = (type, tileInQuestion) ->
		return true if type is tileTypes.any
		return type is tileInQuestion

	aisleHeight = 7
	
	patternWidth = 3
	patternHeight = aisleHeight
	tileWidth = 400 / aisleHeight # ah w/e give 'er

	defaultPatternData = ->
		matchTiles = []
		for x in [0...patternWidth]
			matchTiles.push []
			for y in [0...patternHeight]
				matchTiles[x].push tileTypes.any
		resultTiles = (tileTypes.empty for i in [0...aisleHeight])
		return {matchTiles: matchTiles, resultTiles: resultTiles}

	class ns.Pattern
		constructor: (patternData=null) ->
			patternData = defaultPatternData() if patternData is null
			@matchTiles = patternData.matchTiles
			@resultTiles = patternData.resultTiles

		matches: (tileSet) ->
			for x in [0...patternWidth]
				for y in [0...patternHeight]
					return false unless typeMatches @matchTiles[x][y], tileSet[x][y].type
			return true
	patterns = []

	regularFloorPattern = new ns.Pattern
	regularFloorPattern.resultTiles = ((if i < aisleHeight-1 then tileTypes.empty else tileTypes.wall) for i in [0...aisleHeight])
	patterns.push regularFloorPattern

	class ns.Aisle
		constructor: ->
			@tiles = []
			for i in [0...3]
				@addColumn regularFloorPattern.resultTiles

			for i in [0...100]
				@addNextColumn()

			@camera = {x:0}

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
			@camera.x += 5 if ame.input.isDown 'right'
			@camera.x -= 5 if ame.input.isDown 'left'

		draw: (gfx) ->
			for column in @tiles
				drawTile gfx, tile, @camera for tile in column

	tileColor = (tileType) ->
		switch tileType
			when tileTypes.empty then ame.gfx.colors.GREY
			when tileTypes.wall then ame.gfx.colors.BLACK
			when tileTypes.any then ame.gfx.colors.PURPLE

	drawTile = (gfx, tile, camera={x:0}) ->
		gfx.drawRectangle tile.x * tileWidth - camera.x,
			tile.y * tileWidth,
			tileWidth,
			tileWidth, tileColor(tile.type)

	cycleTileType = (tile) ->
		indexOfCurrentType = tileTypeList.indexOf tile.type
		indexOfNextType = (indexOfCurrentType + 1) % tileTypeList.length
		tile.type = tileTypeList[indexOfNextType]

	class ns.Editor
		constructor: ($canvas) ->
			$canvas.click @click
			$canvas.keypress (e) =>
				@showStuff() if e.keyCode is 32

			patternData = defaultPatternData()
			@matchTiles = []
			for x in [0...patternData.matchTiles.length]
				@matchTiles.push []
				for y in [0...patternData.matchTiles[x].length]
					@matchTiles[x].push {x: x, y: y, type: patternData.matchTiles[x][y]}

			@resultTiles = []
			for y in [0...patternData.resultTiles.length]
				x = @matchTiles.length
				@resultTiles.push {x: x, y: y, type: patternData.resultTiles[y]}

		click: (e) =>
			tileX = Math.floor e.offsetX/tileWidth
			tileY = Math.floor e.offsetY/tileWidth

			tile = null
			if tileX < @matchTiles.length
				tile = @matchTiles[tileX][tileY]
			else if tileX is @matchTiles.length
				tile = @resultTiles[tileY]

			return if tile is null

			cycleTileType tile

		update: (delta) ->

		showStuff: ->
			output =
				matchTiles: @matchTiles
				resultTiles: @resultTiles
			console.log JSON.stringify output

		draw: (gfx) ->
			drawTile gfx, tile for tile in column for column in @matchTiles
			drawTile gfx, tile for tile in @resultTiles
