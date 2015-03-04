Meteor.methods({
	getManifest: function(URL, location, title, user, project){
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

    saveWorkSpace: function(workspace, user, project){
        workspaceJSON = JSON.parse(workspace);
        for(i = 0; i < workspaceJSON.data.length; i++){
            Workspaces.upsert({"user": user, "project": project, "manifestUri": workspaceJSON.data[i].manifestUri}, {$set: {"widgets": workspaceJSON.data[i].widgets}})         
        } 
    },

    getRootUrl: function(){
        return process.env.ROOT_URL;
    }
})