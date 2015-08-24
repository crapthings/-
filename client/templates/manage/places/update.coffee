Template.manageUpdatePlace.events

	'submit form': (e, t) ->
		e.preventDefault()
		opt = form2js 'placeForm'
		Meteor.call 'updatePlace', @_id, opt, (err) ->
			unless err
				Router.go 'managePlaces'
