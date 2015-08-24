#

@Comments = new Mongo.Collection 'comments'

#

Comments.helpers

	formattedCreatedAt: -> moment(@createdAt).format('YYYY.MM.DD')

#

Comments.before.insert (userId, comment) ->
	_.extend comment,
		createdAt: new Date()
		creatorId: userId

#

Meteor.methods

	newComment: (id, opt) ->
		opt.parentId = id
		Comments.insert opt

	updateComment: (id, opt) -> Comments.update id, $set: opt

	removeComment: (id) -> Comments.remove id

#

if Meteor.isServer

	Meteor.publish 'getCommentsByParentId', (parentId) ->
		if @userId
			Meteor.getRecent 'Comments', { parentId: parentId }
		else
			@ready()
