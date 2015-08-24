Template.commentForm.events

	'submit form': (e, t) ->
		e.preventDefault()
		opt = form2js 'commentForm'
		Meteor.call 'newComment', @_id, opt, (err) ->
			unless err
				($ '.reset').trigger 'click'
