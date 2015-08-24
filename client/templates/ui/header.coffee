Template.ui_header.events

	'keypress .action-search': (e, t) ->
		if e.keyCode is 13
			$search = ($ e.currentTarget)
			search = $search.val()
			Session.set 'searchKeyword', search
			$search.val ''
			Router.go 'search', { keyword: search }
