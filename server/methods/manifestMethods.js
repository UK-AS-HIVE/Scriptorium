Meteor.methods({
	getManifest: function(URL, location, title){
        console.log("Adding manifest " + URL);
        AvailableManifests.insert({
            user: "Andy",
            project: 000,
            manifestURL: URL,
            manifestLocation: location,
            manifestTitle: title
        });
	}
})