# ?

@Clients = new Mongo.Collection 'clients'

#
# todo: 推荐人helper可能会遇到问题
Clients.helpers

	formattedCreatedAt: -> moment(@createdAt).format('YYYY.MM.DD')

	place: -> Places.findOne @placeId or null

	referee: -> Clients.findOne(@refereeId) or { displayName: '网络' }

	finish: -> @instalment - @stats.uncompleted

#

Clients.before.insert (userId, client) ->
	_.extend client,
		createdAt: client.createdAt or new Date()
		refereeId: client.refereeId or Random.id()
		balancedOut: false
		stats:
			referees: 0
			uncompleted: client.instalment

#

Clients.after.insert (userId, client) ->
	_createdAt = client.createdAt or new Date()
	Places.update client.placeId,
		$inc:
			'stats.clients': 1
	_(client.instalment).times (n) ->
		Instalments.insert
			createdAt: _createdAt
			clientId: client._id
			completed: false
			startAt: moment(_createdAt).add(n+1, 'M').toDate()
			endAt: moment(_createdAt).add(n+2, 'M').toDate()
			stage: n + 1

	unless client.refereeId is '网络'

		Clients.update client.refereeId,
			$inc:
				'stats.referees': 1

Clients.after.update (userId, client, fieldNames, modifier, options) ->
	if not @previous?.cancel and client.cancel
		Instalments.update { clientId: @client._id },
			$set:
				cancel: true
,
	fetchPrevious: true

#

Meteor.methods

	newClient: (opt) -> Clients.insert opt

	updateClient: (id, opt) -> Clients.update id, $set: opt

	removeClient: (id) -> Clients.remove id

	cancelClient: (id, result) ->
		Clients.update id,
			$set:
				result: result
				cancel: true

# server side

if Meteor.isServer

	# attach referee to client

	Clients.serverTransform

		referee: (client) ->
			Clients.findOne client.refereeId or { displayName: '网络' }

		place: (client) ->
			Places.findOne client.placeId

	# 获取代理

	Meteor.publishTransformed 'getClients', (selector, options)->
		if @userId
			if Meteor.isAdmin @userId
				Clients.find {},
					sort:
						createdAt: -1
					limit: 100
			else
				currentUser = Meteor.users.findOne @userId
				Clients.find { placeId: currentUser.placeId },
					sort:
						createdAt: -1
					limit: 100
		else
			@ready()

	# 用id获取代理

	Meteor.publishTransformed 'getClientById', (id) ->
		if @userId
			Clients.find { $or: [ { _id: id }, { refereeId: id } ] }
		else
			@ready()

	# 关键词搜索

	Meteor.publishTransformed 'getClientsByKeyword', (keyword) ->

		# 管理员
		if Meteor.isAdmin @userId

			# 日期查询
			# if moment(keyword, 'YYYYMMDD').isValid()
			if not _.isNaN(keyword) and _.isNumber(parseInt keyword) and moment(keyword, 'YYYYMMDD').isValid()

				console.log keyword

				# 按日
				if keyword.length is 8
					startOfDay = moment(keyword, 'YYYYMMDD').startOf('day').toDate()
					endOfDay = moment(keyword, 'YYYYMMDD').endOf('day').toDate()
					Clients.find { createdAt: { $gte: startOfDay, $lte: endOfDay } },
						sort:
							createdAt: -1

				# 按月
				else if keyword.length is 6
					firstDayOfMonth = moment(keyword, 'YYYYMM').startOf('month').toDate()
					lastDayOfMonth = moment(keyword, 'YYYYMM').endOf('month').toDate()
					Clients.find { createdAt: { $gte: firstDayOfMonth, $lte: lastDayOfMonth } },
						sort:
							createdAt: -1

				# 按年
				else if keyword.length is 4
					firstDayOfYear = moment(keyword, 'YYYY').startOf('year').toDate()
					lastDayOfYear = moment(keyword, 'YYYY').endOf('year').toDate()
					Clients.find { createdAt: { $gte: firstDayOfYear, $lte: lastDayOfYear } },
						sort:
							createdAt: -1
				else
					@ready()

			# 管理员搜索结果
			else
				regex = new RegExp keyword, 'i'
				clientId = Clients.findOne({ displayName: regex })?._id
				Clients.find {
					$or: [
						{ displayName: regex },
						{ school: regex },
						{ position: regex },
						{ refereeId: clientId },
						{ mobile: regex },
						{ tel: regex },
						{ category: regex },
						{ type: regex }
					]
				},
					sort:
						createdAt: -1
					limit: 100

		# 搜索结果
		else

			if @userId

				if not _.isNaN(keyword) and _.isNumber(parseInt keyword) and moment(keyword, 'YYYYMMDD').isValid()

					# 按日
					if keyword.length is 8
						startOfDay = moment(keyword, 'YYYYMMDD').startOf('day').toDate()
						endOfDay = moment(keyword, 'YYYYMMDD').endOf('day').toDate()
						Clients.find { createdAt: { $gte: startOfDay, $lte: endOfDay } },
							sort:
								createdAt: -1

					# 按月
					else if keyword.length is 6
						firstDayOfMonth = moment(keyword, 'YYYYMM').startOf('month').toDate()
						lastDayOfMonth = moment(keyword, 'YYYYMM').endOf('month').toDate()
						Clients.find { createdAt: { $gte: firstDayOfMonth, $lte: lastDayOfMonth } },
							sort:
								createdAt: -1

					# 按年
					else if keyword.length is 4
						firstDayOfYear = moment(keyword, 'YYYY').startOf('year').toDate()
						lastDayOfYear = moment(keyword, 'YYYY').endOf('year').toDate()
						Clients.find { createdAt: { $gte: firstDayOfYear, $lte: lastDayOfYear } },
							sort:
								createdAt: -1
					else
						@ready()

				else
					currentUser = Meteor.users.findOne @userId
					regex = new RegExp keyword, 'i'
					clientId = Clients.findOne({ displayName: regex })?._id
					Clients.find {
						placeId: currentUser.placeId
						$or: [
							{ displayName: regex },
							{ school: regex },
							{ position: regex },
							{ refereeId: clientId },
							{ mobile: regex },
							{ tel: regex },
							{ category: regex },
							{ type: regex }
						]
					},
						sort:
							createdAt: -1
						limit: 100

	Meteor.publishTransformed 'getCancelClients', ->
		if Meteor.isAdmin @userId
			Clients.find { cancel: true },
				sort:
					createdAt: -1
		else
			user = Meteor.users.findOne @userId
			Clients.find { placeId: user.placeId, cancel: true },
				sort:
					createdAt: -1

	Meteor.startup ->

		Clients._ensureIndex
			displayName: 1
			school: 1
			position: 1
			refereeId: 1
			mobile: 1
			tel: 1
			category: 1
			type: 1
