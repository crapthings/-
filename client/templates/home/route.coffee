Router.route '/', ->
	@render 'home'
,
	name: 'home'
	waitOn: ->
		if Meteor.userId()
			subsCache.subscribe 'getClients'
