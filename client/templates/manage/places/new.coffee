Template.manageNewPlace.events

	'submit form': (e, t) ->
		e.preventDefault()
		opt = form2js 'placeForm'
		Meteor.call 'newPlace', opt, (err) ->
			unless err
				Router.go 'managePlaces'
