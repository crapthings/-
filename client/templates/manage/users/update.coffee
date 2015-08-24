Template.manageUpdateUser.events

	'submit form': (e, t) ->
		e.preventDefault()
		opt = form2js 'userForm'
		Meteor.call 'updateUser', @_id, opt, (err) ->
			unless err
				Router.go 'manageUsers'
