Meteor.methods({
	addFolioItem: function(imageID, userID){

		theDate = new Date();

		newFolioID = folioItems.insert({
			addedBy: userID,
			lastUpdatedBy: userID,
			canvas: null,
			imageURL: imageID,
			metadata: {},
			dateAdded: theDate,
			lastUpdated: theDate,
			published: false,
			manifest: process.env.ROOT_URL + "folio/manifest.json"
		}); 

		return newFolioID
	},

	sendFolioPrep: function(imageID, height, width, title){
		console.log(imageID + " " + height + " " + width + " " + title);
	}

})