faker = Meteor.npmRequire 'faker'

Meteor.startup ->

	Places.remove {}

	Meteor.users.remove {}

	Clients.remove {}

	Instalments.remove {}

	Comments.remove {}

	# 默认地区

	unless Places.findOne {}
		places = ['哈尔滨', '长春']
		for place in places
			Places.insert
				title: place
				address: faker.address.streetAddress()
				tel: faker.phone.phoneNumber()
				leader: faker.name.findName()
				contact: faker.phone.phoneNumber()
				desc: faker.lorem.sentence()

	# 默认管理员

	unless Meteor.users.findOne { username: 'admin' }
		Accounts.createUser
			username: 'admin'
			password: 'admin'
			profile:
				displayName: '管理员'
				isAdmin: true

	# 测试用户

	unless Meteor.users.findOne { username: 'haerbin' }
		Accounts.createUser
			username: 'haerbin'
			password: 'haerbin'
			placeId: (Places.findOne { title: '哈尔滨' })._id
			profile:
				displayName: '哈尔滨演示用户'
				isAdmin: false

	unless Meteor.users.findOne { username: 'changchun' }
		Accounts.createUser
			username: 'changchun'
			password: 'changchun'
			placeId: (Places.findOne { title: '长春' })._id
			profile:
				displayName: '长春演示用户'
				isAdmin: false

	# 测试代理数据

	unless Clients.findOne {}

		_(200).times ->
			placeId = (_.sample Places.find().fetch())._id
			Clients.insert
				placeId: placeId
				userId: (_.sample Meteor.users.find({ placeId: placeId }).fetch()).id
				displayName: faker.name.findName()
				school: faker.lorem.sentence()
				position: _.sample ['区代', '校代', '子代']
				refereeId: (_.sample(Clients.find({ placeId: placeId }).fetch()))?._id
				account: (_.random 1000000000000, 9999999999999).toString()
				bank: _.sample ['招商银行', '交通银行', '工商银行', '建设银行', '农业银行', '广发银行', '光大银行', '农村信用社', '兴业银行']
				alipay: (_.random 1000000000000, 9999999999999).toString()
				mobile: (_.random 13000000000, 18888888888).toString()
				tel: (_.random 20000000, 80000000).toString()
				wechat: (_.random 13000000000, 18888888888).toString()
				qq: (_.random 10000, 10000000).toString()
				login: faker.internet.userName()
				password: Random.id()
				category: _.sample ['iphone', 'ipad', '笔记本']
				colour: _.sample ['黑', '黄', '白']
				total: (_.random 5000, 12000).toFixed(2)
				instalment: _.sample [12, 24, 32]
				amount: ((_.random 5000, 12000) / (_.sample [12, 24, 32]) + (_.random 200, 500)).toFixed(2)
				type: _.sample ['闽宣', '易安', '奔牛']
				createdAt: faker.date.past()
				desc: faker.lorem.sentence()
