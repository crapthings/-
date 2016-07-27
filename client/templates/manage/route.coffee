Router.route '/manage', ->
	@render 'manage'
,
	name: 'manage'
	# waitOn: -> [
	# 	Meteor.subscribe('getUsers'), Meteor.subscribe('getPlaces')
	# ]
