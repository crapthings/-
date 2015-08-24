Router.route '/instalments/date', ->
	@render 'instalmentsByDate'
,
	name: 'instalmentsByDate'
	waitOn: ->
		Meteor.subscribe 'getLastThreeDays', Session.get('currentDate')

Template.instalmentsByDate.rendered = ->

	($ 'table').stickyTableHeaders
		fixedOffset: ($ '.ui-header')

Template.instalmentsByDate.events

	'input .date-picker': (e, t) ->
		e.preventDefault()
		date = ($ e.currentTarget).val()
		Session.set('currentDate', moment(date, 'YYYY-MM-DD').toDate())

	'click .prev-day': ->
		date = Session.get 'currentDate' or new Date()
		Session.set 'currentDate', moment(date).subtract(1, 'd').toDate()

	'click .next-day': ->
		date = Session.get 'currentDate' or new Date()
		Session.set 'currentDate', moment(date).add(1, 'd').toDate()

Template.instalmentsByDate.helpers

	'displayHelperDate': ->
		date = Session.get 'currentDate' or new Date()
		moment(date).format('YYYY.MM.DD') or moment(date).format('YYYY.MM.DD')

Template.instalmentsByDateItem.events

	'click .attach-comment': (e, t) ->
		result = prompt('请输入处理情况')
		cfm = confirm '你确定要这么做吗？'
		if result and cfm
			Meteor.call 'completeInstalment', @_id, result
