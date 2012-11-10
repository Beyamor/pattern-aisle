inNs = (ns, block) ->
	target = window
	target = target[item] or= {} for item in ns.split '.'
	block target

inNs 'ame', (ns) ->
	ns.ns = inNs
