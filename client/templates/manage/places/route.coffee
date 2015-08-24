Router.route '/manage/places', ->
	@render 'managePlaces'
,
	name: 'managePlaces'

Router.route '/manage/places/new', ->
	@render 'manageNewPlace'
,
	name: 'manageNewPlace'

Router.route '/manage/places/update/:_id', ->
	@render 'manageUpdatePlace',
		data: ->
			place: Places.findOne @params._id
,
	name: 'manageUpdatePlace'
