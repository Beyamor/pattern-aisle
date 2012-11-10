ame.ns 'ame.math', (ns) ->
	ns.PI = Math.PI
	ns.PI_BY_2 = Math.PI / 2
	ns.SQRT2 = Math.sqrt(2)

	ns.sign = (x) ->
		(x > 0) - (x < 0)

	ns.radToDeg = (rad) ->
		rad * 180 / ns.PI

	ns.degToRad = (deg) ->
		deg * ns.PI / 180

	class ns.Vec2
		constructor: (@x=0, @y=0) ->

		equals: (other) ->
			@x == other.x and @y == other.y

		plus: (other) ->
			new Vec2 @x + other.x, @y + other.y

		minus: (other) ->
			new Vec2 @x - other.x, @y - other.y

		times: (scale) ->
			new Vec2 @x * scale, @y * scale

		magnitudeSquared: ->
			@x*@x + @y*@y

		magnitude: ->
			Math.sqrt @magnitudeSquared()

		direction: ->
			ns.radToDeg(Math.atan2 @y, @x)

		normal: ->
			magnitude = @magnitude()

			if magnitude != 0
				return @times(1.0 / magnitude)
			else
				return new Vec2 0, 0

		distanceSquaredTo: (other) ->
			other.minus(this).magnitudeSquared()

		distanceTo: (other) ->
			other.minus(this).magnitude()

		directionTo: (other) ->
			other.minus(this).direction()

		dot: (other) ->
			@x * other.x + @y * other.y

		@fromAngle: (theta, magnitude=1) ->
			theta = ns.degToRad theta
			return new Vec2 magnitude * Math.cos(theta), magnitude * Math.sin(theta)

	class ns.Segment
		constructor: (@p1, @p2) ->

		isZeroLength: ->
			@p1.x==@p2.x && @p1.y==@p2.y

		lengthSquared: ->
			(@p2.minus @p1).magnitudeSquared()

	ns.closestPointOnSegment = (s, p) ->
		# yoink: http://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
		return s.p1 if s.isZeroLength()

		t = (p.minus s.p1).dot(s.p2.minus s.p1) / s.lengthSquared()

		return s.p1 if t < 0
		return s.p2 if t > 1

		projection = s.p1.plus((s.p2.minus s.p1).times t)
		return projection
