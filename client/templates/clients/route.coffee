Router.route '/clients/new', ->
	@render 'newClient'
,
	name: 'newClient'

Router.route '/clients/update/:_id', ->
	@render 'updateClient',
		data: ->
			client: Clients.findOne @params._id
,
	name: 'updateClient'
	waitOn: ->
		[ Meteor.subscribe('getClientById', @params._id), Meteor.subscribe('getInstalmentsByClientId', @params._id), Meteor.subscribe('getCommentsByParentId', @params._id) ]

Router.route '/clients/view/:_id', ->
	@render 'viewClient',
		data: ->
			client: Clients.findOne @params._id
,
	name: 'viewClient'
	waitOn: ->
		[ Meteor.subscribe('getClientById', @params._id), Meteor.subscribe('getInstalmentsByClientId', @params._id), Meteor.subscribe('getCommentsByParentId', @params._id) ]

Router.route '/Clients/cancel', ->
	@render 'getCancelClients',
		data: ->
			getCancelClients: Clients.find { cancel: true },
				sort:
					createdAt: -1
,
	name: 'getCancelClients'
	waitOn: ->
		Meteor.subscribe 'getCancelClients'
