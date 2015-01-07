Meteor.methods({
	getManifest: function(URL, location, title, user, project){
        console.log("Adding manifest " + URL);
        console.log(user + " " + project);
        HTTP.get(URL, function(err, result){
            console.log("in the thing");
            if(result.statusCode == 200){
                console.log("it works");
                AvailableManifests.insert({
                    user: user,
                    project: project,
                    manifestPayload: JSON.parse(result.content),
                    manifestLocation: location,
                    manifestTitle: title
                });
            };
            
        });

	},

    getRootUrl: function(){
        return process.env.ROOT_URL;
    }
})