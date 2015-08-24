Template.viewClient.events

	'click .attach-comment': (e, t) ->
		result = prompt('请输入处理情况')
		cfm = confirm '你确定要这么做吗？'
		if result and cfm
			Meteor.call 'completeInstalment', @_id, result

	'click .cancel-user': (e, t) ->
		result = prompt '请输入处理情况'
		cfm = confirm '你确定要这么做吗？'
		if result and cfm
			Meteor.call 'cancelClient', @_id, result

	'click .balancedOut': (e, t) ->
		stage = prompt '请输入要抵消哪一期？'
		result = prompt '请输入备注'
		instalment = Instalments.findOne { clientId: @refereeId, stage: parseInt(stage) }
		cfm = confirm '你确定要这么做吗？'
		if stage and instalment and cfm
			console.log instalment
			Meteor.call 'balancedOutInstalment', instalment._id, instalment.stage, result, @_id
