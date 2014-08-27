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
	},

    getRootUrl: function(){
        console.log("foo");
        return process.env.ROOT_URL;
    }
})