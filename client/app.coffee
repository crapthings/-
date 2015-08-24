Session.setDefault 'currentDate', new Date()

Router.configure

	layoutTemplate: 'layout_default'
	loadingTemplate: 'loadingTemplate'

Router.onBeforeAction ->
	unless Meteor.userId()
		@layout 'layout_blank'
		@render 'login'
	else
		@next()
,
	except: ['login']

Router.onAfterAction ->
	($ window).scrollTop 0

Router.onBeforeAction ->
	unless Meteor.isAdmin Meteor.userId()
		@render 'unauth'
	else
		@next()
,
	except: ['home', 'instalmentsByDate', 'getCancelClients', 'newClient', 'search', 'viewClient']
