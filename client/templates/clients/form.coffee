Template.clientForm.events

	'keyup #refereesList1': (e, t) ->
		keyword = ($ e.currentTarget).val()
		Session.set 'findRefereer', keyword
		Meteor.subscribe 'getClientsByKeyword', keyword
