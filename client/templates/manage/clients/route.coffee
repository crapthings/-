Router.route '/manage/clients', ->
	@render 'manageClients'
,
	name: 'manageClients'

Router.route '/manage/clients/update/:_id', ->
	@render 'manageUpdateClient',
		data: ->
			client: Clients.findOne @params._id
,
	name: 'manageUpdateClient'
	waitOn: ->
		Meteor.subscribe 'getClientById', @params._id
