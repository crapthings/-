Template.manageNewUser.events

	'submit form': (e, t) ->
		e.preventDefault()
		opt = form2js 'userForm'
		Meteor.call 'newUser', opt, (err) ->
			unless err
				Router.go 'manageUsers'
