_.extend Meteor,

	signout: ->
		cfm = confirm '确定要退出吗？'
		if cfm
			Meteor.logout (err) ->
				unless err
					Router.go 'home'
