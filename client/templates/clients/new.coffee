Template.newClient.events

	'submit form': (e, t) ->
		e.preventDefault()
		opt = form2js 'clientForm'
		Meteor.call 'newClient', opt, (err) ->
			unless err
				Router.go 'home'
