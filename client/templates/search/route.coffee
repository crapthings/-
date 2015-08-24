Router.route '/search/:keyword', ->
	@render 'search'
, {
	name: 'search'
	, onBeforeAction: ->
		Session.set('searchKeyword', @params.keyword)
		@next()
	, waitOn: ->
		subsCache.subscribe('getClientsByKeyword', @params.keyword)
}
