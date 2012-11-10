ame.ns 'ame.gamestates', (ns) ->

	td = ame.td

	class TimeBasedTransition
		constructor: (@transitionPeriod=1) ->
			@elapsed = 0
			@isFinished = false

		update: (delta) ->
			@elapsed += delta
			@isFinished = (@elapsed >= @transitionPeriod)

	class ns.FadeOutTransition extends TimeBasedTransition
		draw: (gfx) ->
			alpha = if @elapsed > 1 then 1 else @elapsed
			gfx.drawRectangle 0, 0, gfx.width, gfx.height, ame.gfx.colors.BLACK, alpha

	class ns.FadeInTransition extends TimeBasedTransition
		draw: (gfx) ->
			alpha = if @elapsed > 1 then 0 else 1 - @elapsed
			gfx.drawRectangle 0, 0, gfx.width, gfx.height, ame.gfx.colors.BLACK, alpha

	ns.standardTransition = ->
		out: new ns.FadeOutTransition
		in: new ns.FadeInTransition

	class ns.PlayState
		constructor: ->
			@entities = []
			@entities.push new ame.td.Monster new ame.td.WaypointList, 200, 200

			sphere = new td.CarvedSphere 300, 300
			sphere.sliceAt Math.PI
			sphere.sliceAt Math.PI * 3 /4
			sphereDrawer = new td.CarvedSphereDrawer sphere
			@entities.push sphereDrawer

		update: (delta) ->
			entity.update delta for entity in @entities

		draw: (gfx) ->
			entity.draw gfx for entity in @entities


	class ns.StateMachine
		constructor: (initialState) ->
			@sequencer = new ame.util.Sequencer
			@currentState = initialState

		changeState: (state, transition) ->
			@sequencer.push transition.out if transition? and transition.out?
			@sequencer.push
				update: (delta) =>
					@currentState = state
			@sequencer.push transition.in if transition? and transition.in?

		update: (delta) ->
			@sequencer.update delta
			@currentState.update delta if @currentState? and @sequencer.isEmpty()

		draw: (gfx) ->
			@currentState.draw gfx if @currentState.draw
			@sequencer.items[0].draw gfx if @sequencer.items.length > 0 and @sequencer.items[0].draw?
