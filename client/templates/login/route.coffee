Router.route '/login'

Template.login.events

	'submit form': (e, t) ->
		e.preventDefault()
		opt = form2js 'loginForm'
		Meteor.loginWithPassword opt.username, opt.password, (err) ->
			unless err
				Router.go 'home'
