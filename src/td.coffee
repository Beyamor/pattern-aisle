ame.ns 'ame.td', (ns) ->

	class ns.CarvedSphere
		constructor: (@x, @y) ->
			@slices = []
			@arcs = []
			@refabulateArcs()

		normalize: (angle) ->
			angle += Math.PI * 2 while angle < 0
			angle -= Math.PI * 2 while angle > Math.PI * 2
			return angle

		addSlice: (angle) ->
			begin = @normalize angle - Math.PI/2
			end = @normalize angle + Math.PI/2
			@slices.push {begin: begin, end: end}

		encompassesEntireArc: (slice, arc) ->
			slice.begin < arc.begin and slice.end > arc.end

		encompassesStartOfArc: (slice, arc) ->
			slice.begin < arc.begin and slice.end > arc.begin and slice.end < arc.end

		encompassesEndOfArc: (slice, arc) ->
			slice.end > arc.end and slice.begin < arc.end and slice.begin > arc.begin

		dividesArc: (slice, arc) ->
			slice.begin > arc.begin and slice.end < arc.end

		removeSlice: (slice) ->
			if slice.begin > slice.end
				@removeSlice {begin: slice.begin - Math.PI * 2, end: slice.end}
				@removeSlice {begin: slice.begin, end: slice.end + Math.PI * 2}
			else
				arcsToRemove = []
				arcsToAdd = []
				for arc in @arcs
					if @encompassesEntireArc slice, arc
						arcsToRemove.push arc
					else if @encompassesStartOfArc slice, arc
						arc.begin = slice.end
					else if @encompassesEndOfArc slice, arc
						arc.end = slice.begin
					else if @dividesArc slice, arc
						arcsToAdd.push {begin: arc.begin, end: slice.begin}
						arcsToAdd.push {begin: slice.end, end: arc.end}
						arcsToRemove.push arc

				@arcs = (arc for arc in @arcs when arcsToRemove.indexOf(arc) is -1)
				@arcs.push arc for arc in arcsToAdd
		
		restitchArcs: ->
			arcAtZero = null
			arcAtZero = arc for arc in @arcs when arc.begin is 0
			return if arcAtZero == null

			arcAt2PI = null
			arcAt2PI = arc for arc in @arcs when arc.end is 2 * Math.PI
			return if arcAt2PI == null

			arcAtZero.begin = arcAt2PI.begin - 2 * Math.PI
			@arcs = (arc for arc in @arcs when arc != arcAt2PI)

		refabulateArcs: (angle) ->
			@arcs = [{begin: 0, end: 2 * Math.PI}]
			return if @slices.length is 0

			# okay. jesus fuck. you can do this.
			# we started with a full arc.
			# now, just, like, slice bits out of it
			for slice in @slices
				@removeSlice slice

			# awesome. fucking' amazing.
			# now stitch that bitch back together.
			@restitchArcs()

		sliceAt: (angle) ->
			@addSlice angle
			@refabulateArcs()

		getArcs: ->
			return @arcs

	class ns.CarvedSphereDrawer
		constructor: (@sphere) ->

		update: ->

		draw: (gfx) ->
			for arc in @sphere.getArcs()
				gfx.drawArc @sphere.x, @sphere.y, 24, arc.begin, arc.end, ame.gfx.colors.GRAY

	class ns.WaypointList
		constructor: (@waypoints...) ->

	class ns.Monster
		constructor: (@waypointList, @x, @y) ->
			@waypoint = 0

		update: (delta) ->
			moveTowardsPoint = @waypoint < @waypointList.length

		draw: (gfx) ->
			gfx.drawCircle @x, @y, 24, ame.gfx.colors.BLUE
