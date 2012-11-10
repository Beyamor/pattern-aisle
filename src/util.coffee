ame.ns 'ame.util', (ns) ->

	class ns.Sequencer
		constructor: ->
			@items = []

		push: (item) ->
			item.isFinished = true unless item.isFinished?
			@items.push item

		update: (delta) ->

			while @items.length > 0

				item = @items[0]

				item.update delta
				return unless item.isFinished

				@items.shift()

		isEmpty: ->
			@items.length == 0
