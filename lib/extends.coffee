#

self = @

#

_.extend Meteor,

	# check user is an administrator ?
	isAdmin: (userId) -> (Meteor.users.findOne userId)?.profile.isAdmin

	adminRun: (userId, run) -> run if Meteor.isAdmin userId

	getRecent: (collectionName, selector = {}, options = { sort: createdAt: -1 }) ->
		unless collectionName
			console.log 'you have to specify a collection name.'
			return
		self[collectionName].find selector, options

#

Meteor.methods

	removeDoc: (collectionName, docId) -> self[collectionName].remove docId
