Meteor.methods({
	addFolioItem: function(imageID, userID){

		theDate = new Date();

		newFolioID = folioItems.insert({
			addedBy: userID,
			lastUpdatedBy: userID,
			canvas: null,
			imageURL: imageID,
			metadata: null,
			dateAdded: theDate,
			lastUpdated: theDate,
			published: false,
			manifest: process.env.ROOT_URL + "folio/manifest.json"
		}); 

		return newFolioID
	},

	saveFolioForm: function(formData){

		console.log("Saving Folio item...");

		folioItems.insert({
			user: 'andy',
			project: 000,
			folioItem: formData
		});


	},

	sendFolioPrep: function(imageID, height, width, title){
		console.log(imageID + " " + height + " " + width + " " + title);
	}

})