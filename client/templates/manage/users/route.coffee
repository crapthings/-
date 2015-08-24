Router.route '/manage/users', ->
	@render 'manageUsers'
,
	name: 'manageUsers'
	waitOn: ->
		Meteor.subscribe 'getUsers'

Router.route '/manage/users/new', ->
	@render 'manageNewUser'
,
	name: 'manageNewUser'

Router.route '/manage/users/update/:_id', ->
	@render 'manageUpdateUser',
		data: ->
			user: Users.findOne @params._id
,
	name: 'manageUpdateUser'
	waitOn: ->
		Meteor.subscribe 'getUser', @params._id
