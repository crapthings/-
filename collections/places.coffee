#

@Places = new Mongo.Collection 'places'

#

Places.helpers

	formattedCreatedAt: ->
		moment(@createdAt).format('YYYY.MM.DD')

#

Places.before.insert (userId, place) ->
	_.extend place,
		createdAt: new Date()
		stats:
			users: place.stats?.users or 0
			clients: place.stats?.clients or 0

#

Meteor.methods

	newPlace: (opt) -> Places.insert opt

	updatePlace: (id, opt) -> Places.update id, $set: opt

	removePlace: (id) -> Places.remove id

#

if Meteor.isServer

	Meteor.publish null, ->
		if Meteor.isAdmin @userId
			Meteor.getRecent 'Places'
		else
			@ready()
