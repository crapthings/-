Template.updateClient.events

	'submit form': (e, t) ->
		e.preventDefault()
		opt = form2js 'clientForm'
		Meteor.call 'updateClient', @_id, opt, (err) ->
			unless err
				Router.go 'home'
