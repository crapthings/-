Template.usersTableRow.events

	'click .remove-user': ->
		if confirm '确定删除吗'
			Meteor.call 'removeUser', @_id
