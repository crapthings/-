#
@Instalments = new Mongo.Collection 'instalments'

#
Instalments.helpers

	client: -> Clients.findOne @clientId

	referee: -> Clients.findOne @refereeId

	formattedCreatedAt: -> moment(@createdAt).format('YYYY.MM.DD')

	formattedStartAt: -> moment(@startAt).format('YYYY.MM.DD')

	formattedEndAt: -> moment(@endAt).format('YYYY.MM.DD')

#
Instalments.before.insert (userId, instalment) ->
	_.extend instalment,
		createdAt: instalment.createdAt or new Date()

Instalments.after.update (userId, instalment, fieldNames, modifier, options) ->
	if not @previous?.completed and instalment.completed
		Clients.update instalment.clientId,
			$inc:
				'stats.uncompleted': -1
,
	fetchPrevious: true

#
Meteor.methods

	balancedOutInstalment: (id, stage, result, clientId) ->
		Instalments.update { _id: id, stage: stage },
			$set:
				result: result
				completed: true
				balancerId: clientId

		Clients.update clientId,
			$set:
				balancedOut: true
				balancedOutStage: stage
				balancedOutAt: new Date()

	newInstalment: (opt) -> Instalments.insert opt

	updateInstalment: (id, opt) -> Instalments.update id, $set: opt

	removeInstalment: (id) -> Instalments.remove id

	completeInstalment: (id, opt) ->
		Instalments.update id,
			$set:
				result: opt
				completed: true

#
if Meteor.isClient

	Template.registerHelper 'instalments', ->
		Instalments.find {},
			sort:
				createdAt: -1

	Template.registerHelper 'instalmentsByDate', (date) ->
		startOfMonth = moment(date).startOf('month').toDate()
		endOfMonth = moment(date).endOf('month').toDate()
		Instalments.find { endAt: { $gte: startOfMonth, $lte: endOfMonth } },
			sort:
				endAt: -1

	Template.registerHelper 'instalmentsByClientId', (clientId) ->
		Instalments.find { clientId: clientId },
			sort:
				stage: 1

	Template.registerHelper 'latestInstalments', ->
		Instalments.find {},
			sort:
				createdAt: -1

if Meteor.isServer

	Instalments.serverTransform

		client: (instalment) ->
			Clients.findOne instalment.clientId

		referee: (instalment) ->
			Clients.findOne instalment.client?.refereeId or { displayName: '网络' }

	Meteor.publish 'getInstalmentsByClientId', (clientId) ->
		if @userId
			Instalments.find { clientId: clientId },
				sort:
					createdAt: 1
		else
			@ready()

	Meteor.publishTransformed 'getLastThreeDays', (date) ->
		if @userId
			prevDays = moment(date).add(3, 'days').startOf('day').toDate()
			nextDays = moment(prevDays).endOf('day').toDate()
			Instalments.find { completed: false, endAt: { $gte: prevDays, $lte: nextDays } },
				sort:
					endAt: 1
		else
			@ready()
