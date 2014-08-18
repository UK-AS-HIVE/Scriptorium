Meteor.methods({
	saveFolioForm: function(formData){

		console.log("Saving Folio item...");

		folioItems.insert({
			user: 'andy',
			project: 000,
			folioItem: formData
		});


	}

})