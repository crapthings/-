Template.managePlaces.rendered = ->

	ctx = document.getElementById('thisMonthGrow').getContext('2d')

	data = {
		labels: ["January", "February", "March", "April", "May", "June", "July"],
		datasets: [
			{
				label: "My First dataset",
				fillColor: "rgba(220,220,220,0.5)",
				strokeColor: "rgba(220,220,220,0.8)",
				highlightFill: "rgba(220,220,220,0.75)",
				highlightStroke: "rgba(220,220,220,1)",
				data: [65, 59, 80, 81, 56, 55, 40]
			},
			{
				label: "My First dataset",
				fillColor: "rgba(65, 105, 225, .9)",
				strokeColor: "rgba(220,220,220,0.8)",
				highlightFill: "rgba(220,220,220,0.75)",
				highlightStroke: "rgba(220,220,220,1)",
				data: [72, 42, 32, 103, 87, 90, 67]
			}
		]
	}

	console.log _.pluck(Places.find().fetch(), 'clients')

	chart1 = new Chart(ctx).Bar(data, {})
