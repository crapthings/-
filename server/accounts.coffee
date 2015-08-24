# 创建用户时保留地点信息
Accounts.onCreateUser (options, user) ->

	if options.profile
		user.profile = options.profile

	if options.placeId
		user.placeId = options.placeId

	return user
