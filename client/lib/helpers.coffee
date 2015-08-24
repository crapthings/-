Session.setDefault 'currentDate', new Date()

helper = Template.registerHelper

# form

helper 'formattedDate', (date, format = 'YYYY.MM.DD') ->
	moment(date).format(format)

helper 'getRadio', (a, b) -> a is b

# string

helper 'truncate', (string, length) -> (string).truncate length

# important helpers

helper 'isAdmin', ->
	Meteor.user().profile?.isAdmin

helper 'getCurrentDate', ->
	currentDate = Session.get 'currentDate'
	currentDate or new Date()

helper 'getDate', ->
	currentDate = Session.get 'currentDate'
	currentDate or new Date()

# places
helper 'places', -> Places.find {}, sort: createdAt: -1

# clients
helper 'clients', -> Clients.find {}, sort: createdAt: -1

helper 'getLastThreeDays', (date) ->
	prevDays = moment(date).add(3, 'days').startOf('day').toDate()
	nextDays = moment(prevDays).endOf('day').toDate()
	Instalments.find { completed: false, endAt: { $gte: prevDays, $lte: nextDays } },
		sort:
			endAt: 1

helper 'getLatestClients', ->
	Clients.find {},
		sort:
			createdAt: -1
		limit: 200

helper 'getReferralsById', (clientId) ->
	Clients.find { refereeId: clientId, balancedOut: true },
		sort:
			createdAt: -1

helper 'getUnbalancedOutReferralsById', (clientId) ->
	Clients.find { refereeId: clientId, balancedOut: false },
		sort:
			createdAt: -1

# users

helper 'users', (limit = 0) ->
	Users.find {},
		sort:
			createdAt: -1
		limit: limit

helper 'getAdminUsers', ->
	Users.find { 'profile.isAdmin': true },
		sort:
			createdAt: -1

helper 'getNormalUsers', ->
	Users.find { 'profile.isAdmin': false },
		sort:
			createdAt: -1

helper 'getLatestUsers', ->
	Users.find {},
		sort:
			createdAt: -1
		limit: 100

# search

helper 'getSearchResults', ->
	keyword = Session.get 'searchKeyword'
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

helper 'findRefereer', (limit=0)->
	keyword = Session.get 'findRefereer'
	regex = new RegExp keyword, 'i'
	Clients.find { displayName: regex },
		sort:
			displayName: -1
		limit: limit

# comments

helper 'getCommentsByParentId', (parentId) ->
	Comments.find { parentId: parentId },
		sort:
			createdAt: -1

