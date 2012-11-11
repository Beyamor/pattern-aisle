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
				matchTiles[x].push {x: x, y: y, type: tileTypes.any}
		resultTiles = ({x: patternWidth, y: y, type: tileTypes.empty} for y in [0...aisleHeight])
		return {matchTiles: matchTiles, resultTiles: resultTiles}

	class ns.Pattern
		constructor: (patternData=null) ->
			patternData = defaultPatternData() if patternData is null
			@matchTiles = patternData.matchTiles
			@resultTiles = patternData.resultTiles

		matches: (tileSet) ->
			for x in [0...patternWidth]
				for y in [0...patternHeight]
					return false unless typeMatches @matchTiles[x][y].type, tileSet[x][y].type
			return true

	ns.patterns = []

	regularFloorPattern = new ns.Pattern
	regularFloorPattern.resultTiles[y].type = (if y < aisleHeight-1 then tileTypes.empty else tileTypes.wall) for y in [0...aisleHeight]
	ns.patterns.push regularFloorPattern

	addPattern = (data) ->
		ns.patterns.push new ns.Pattern data

	addPattern {"matchTiles":[[{"x":0,"y":0,"type":"any"},{"x":0,"y":1,"type":"any"},{"x":0,"y":2,"type":"any"},{"x":0,"y":3,"type":"any"},{"x":0,"y":4,"type":"any"},{"x":0,"y":5,"type":"any"},{"x":0,"y":6,"type":"wall"}],[{"x":1,"y":0,"type":"any"},{"x":1,"y":1,"type":"any"},{"x":1,"y":2,"type":"any"},{"x":1,"y":3,"type":"any"},{"x":1,"y":4,"type":"any"},{"x":1,"y":5,"type":"empty"},{"x":1,"y":6,"type":"wall"}],[{"x":2,"y":0,"type":"any"},{"x":2,"y":1,"type":"any"},{"x":2,"y":2,"type":"any"},{"x":2,"y":3,"type":"any"},{"x":2,"y":4,"type":"empty"},{"x":2,"y":5,"type":"any"},{"x":2,"y":6,"type":"wall"}]],"resultTiles":[{"x":3,"y":0,"type":"empty"},{"x":3,"y":1,"type":"empty"},{"x":3,"y":2,"type":"empty"},{"x":3,"y":3,"type":"empty"},{"x":3,"y":4,"type":"empty"},{"x":3,"y":5,"type":"wall"},{"x":3,"y":6,"type":"wall"}]}

	addPattern {"matchTiles":[[{"x":0,"y":0,"type":"any"},{"x":0,"y":1,"type":"any"},{"x":0,"y":2,"type":"any"},{"x":0,"y":3,"type":"any"},{"x":0,"y":4,"type":"any"},{"x":0,"y":5,"type":"any"},{"x":0,"y":6,"type":"wall"}],[{"x":1,"y":0,"type":"any"},{"x":1,"y":1,"type":"any"},{"x":1,"y":2,"type":"any"},{"x":1,"y":3,"type":"any"},{"x":1,"y":4,"type":"any"},{"x":1,"y":5,"type":"any"},{"x":1,"y":6,"type":"wall"}],[{"x":2,"y":0,"type":"any"},{"x":2,"y":1,"type":"any"},{"x":2,"y":2,"type":"any"},{"x":2,"y":3,"type":"wall"},{"x":2,"y":4,"type":"any"},{"x":2,"y":5,"type":"any"},{"x":2,"y":6,"type":"wall"}]],"resultTiles":[{"x":3,"y":0,"type":"empty"},{"x":3,"y":1,"type":"empty"},{"x":3,"y":2,"type":"empty"},{"x":3,"y":3,"type":"wall"},{"x":3,"y":4,"type":"empty"},{"x":3,"y":5,"type":"empty"},{"x":3,"y":6,"type":"wall"}]}

	addPattern {"matchTiles":[[{"x":0,"y":0,"type":"any"},{"x":0,"y":1,"type":"any"},{"x":0,"y":2,"type":"any"},{"x":0,"y":3,"type":"any"},{"x":0,"y":4,"type":"any"},{"x":0,"y":5,"type":"any"},{"x":0,"y":6,"type":"wall"}],[{"x":1,"y":0,"type":"any"},{"x":1,"y":1,"type":"any"},{"x":1,"y":2,"type":"any"},{"x":1,"y":3,"type":"wall"},{"x":1,"y":4,"type":"any"},{"x":1,"y":5,"type":"any"},{"x":1,"y":6,"type":"wall"}],[{"x":2,"y":0,"type":"any"},{"x":2,"y":1,"type":"any"},{"x":2,"y":2,"type":"any"},{"x":2,"y":3,"type":"empty"},{"x":2,"y":4,"type":"any"},{"x":2,"y":5,"type":"any"},{"x":2,"y":6,"type":"wall"}]],"resultTiles":[{"x":3,"y":0,"type":"empty"},{"x":3,"y":1,"type":"empty"},{"x":3,"y":2,"type":"empty"},{"x":3,"y":3,"type":"wall"},{"x":3,"y":4,"type":"empty"},{"x":3,"y":5,"type":"empty"},{"x":3,"y":6,"type":"wall"}]}

	addPattern {"matchTiles":[[{"x":0,"y":0,"type":"any"},{"x":0,"y":1,"type":"any"},{"x":0,"y":2,"type":"any"},{"x":0,"y":3,"type":"any"},{"x":0,"y":4,"type":"any"},{"x":0,"y":5,"type":"any"},{"x":0,"y":6,"type":"wall"}],[{"x":1,"y":0,"type":"any"},{"x":1,"y":1,"type":"any"},{"x":1,"y":2,"type":"any"},{"x":1,"y":3,"type":"any"},{"x":1,"y":4,"type":"empty"},{"x":1,"y":5,"type":"any"},{"x":1,"y":6,"type":"wall"}],[{"x":2,"y":0,"type":"any"},{"x":2,"y":1,"type":"any"},{"x":2,"y":2,"type":"any"},{"x":2,"y":3,"type":"any"},{"x":2,"y":4,"type":"any"},{"x":2,"y":5,"type":"empty"},{"x":2,"y":6,"type":"wall"}]],"resultTiles":[{"x":3,"y":0,"type":"empty"},{"x":3,"y":1,"type":"empty"},{"x":3,"y":2,"type":"empty"},{"x":3,"y":3,"type":"empty"},{"x":3,"y":4,"type":"wall"},{"x":3,"y":5,"type":"empty"},{"x":3,"y":6,"type":"wall"}]}

	addPattern {"matchTiles":[[{"x":0,"y":0,"type":"any"},{"x":0,"y":1,"type":"any"},{"x":0,"y":2,"type":"any"},{"x":0,"y":3,"type":"any"},{"x":0,"y":4,"type":"any"},{"x":0,"y":5,"type":"any"},{"x":0,"y":6,"type":"wall"}],[{"x":1,"y":0,"type":"any"},{"x":1,"y":1,"type":"any"},{"x":1,"y":2,"type":"any"},{"x":1,"y":3,"type":"empty"},{"x":1,"y":4,"type":"wall"},{"x":1,"y":5,"type":"any"},{"x":1,"y":6,"type":"wall"}],[{"x":2,"y":0,"type":"any"},{"x":2,"y":1,"type":"any"},{"x":2,"y":2,"type":"any"},{"x":2,"y":3,"type":"empty"},{"x":2,"y":4,"type":"any"},{"x":2,"y":5,"type":"any"},{"x":2,"y":6,"type":"wall"}]],"resultTiles":[{"x":3,"y":0,"type":"empty"},{"x":3,"y":1,"type":"empty"},{"x":3,"y":2,"type":"empty"},{"x":3,"y":3,"type":"wall"},{"x":3,"y":4,"type":"wall"},{"x":3,"y":5,"type":"wall"},{"x":3,"y":6,"type":"wall"}]}

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
			matchingPatterns = (pattern for pattern in ns.patterns when pattern.matches columnsToMatch)
			console.log "whoa no matching pattern" if matchingPatterns.length is 0
			aMatchingPattern = matchingPatterns[Math.floor(Math.random() * matchingPatterns.length)]
			@addColumn aMatchingPattern.resultTiles

		addColumn: (tiles) ->
			column = []
			x = @tiles.length
			for y in [0...aisleHeight]
				column.push {x:x, y:y, type:tiles[y].type}
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

	isValidLevelTileType = (type) ->
		type != tileTypes.any

	cycleValidLevelTileType = (tile) ->
		cycleTileType tile
		cycleTileType tile while not isValidLevelTileType tile.type

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
					@matchTiles[x].push patternData.matchTiles[x][y]

			@resultTiles = []
			for y in [0...patternData.resultTiles.length]
				x = @matchTiles.length
				@resultTiles.push patternData.resultTiles[y]
				@resultTiles[y].x = @matchTiles.length

		click: (e) =>
			tileX = Math.floor e.offsetX/tileWidth
			tileY = Math.floor e.offsetY/tileWidth

			if tileX < @matchTiles.length
				cycleTileType @matchTiles[tileX][tileY]
			else if tileX is @matchTiles.length
				cycleValidLevelTileType @resultTiles[tileY]

		update: (delta) ->

		showStuff: ->
			output =
				matchTiles: @matchTiles
				resultTiles: @resultTiles
			console.log JSON.stringify output

		draw: (gfx) ->
			drawTile gfx, tile for tile in column for column in @matchTiles
			drawTile gfx, tile for tile in @resultTiles
