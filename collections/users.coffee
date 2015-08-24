# 不使用 Users

@Users = Meteor.users

#

Meteor.users.helpers

	place: -> Places.findOne @placeId or {}

	formattedCreatedAt: -> moment(@createdAt).format('YYYY.MM.DD')

	displayName: -> @profile?.displayName or @username

	isAdmin: -> @profile?.isAdmin or false

#

Meteor.users.before.insert (userId, user) ->
	_.extend user,
		createdAt: user.createdAt or new Date()

#

Meteor.users.after.insert (userId, user) ->
	Places.update user.placeId,
		$inc:
			'stats.users': 1

# 更新用户表单时候忽略密码字段

Meteor.users.before.update (userId, user) -> delete user.password if user.password

#

Meteor.methods

	newUser: (opt) ->
		Meteor.adminRun @userId, Accounts.createUser opt

	updateUser: (id, opt) ->
		Meteor.adminRun @userId, Meteor.users.update id, $set: opt

	removeUser: (id) ->
		Meteor.adminRun @userId, Meteor.users.remove id

	setUserPassword: (id, password) ->
		Meteor.adminRun @userId, Accounts.setPassword id, password

#

if Meteor.isServer

	Meteor.publish null, ->
		if @userId
			Meteor.users.find { _id: @userId },
				fields:
					services: false
		else
			@ready()

	Meteor.publish 'getUsers', ->
		if Meteor.isAdmin @userId
			Meteor.users.find {},
				sort:
					createdAt: -1
				fields:
					services: false
		else
			@ready()

	Meteor.publish 'getUser', (id) ->
		if Meteor.isAdmin @userId
			Meteor.users.find { _id: id },
				fields:
					services: false
		else
			@ready()
