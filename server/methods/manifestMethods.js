Meteor.methods({
	getManifest: function(URL, location, title, user, project){
        HTTP.get(URL, function(err, result){
            console.log("in the thing");
            if(result.statusCode == 200){
                AvailableManifests.insert({
                    user: user,
                    project: project,
                    manifestPayload: JSON.parse(result.content),
                    manifestLocation: location,
                    manifestTitle: title
                });
            }
        });

	},

    shareManifests: function(user, newProject, sharedManifest, widgets){

        newManifest = AvailableManifests.insert({
            user: user,
            project: newProject,
            manifestPayload: sharedManifest.payload,
            manifestLocation: sharedManifest.location,
            manifestTitle: sharedManifest.title
        });
        return {"id": newManifest, "widgets": widgets, "project": newProject};
    },

    addDataToProject: function(project, manifestId, widgets){
        manifestData = {
            manifestId: manifestId,
            widgets: widgets
        };

        Projects.update({"_id": project}, {$push: {"miradorData": manifestData}});


    },

    testingStuff: function(){
        console.log("things");
    },

    saveWorkSpace: function(workspace, user, project){
        workspaceJSON = JSON.parse(workspace);
        for(i = 0; i < workspaceJSON.data.length; i++){
            Workspaces.upsert({"user": user, "project": project, "manifestUri": workspaceJSON.data[i].manifestUri}, {$set: {"widgets": workspaceJSON.data[i].widgets}});
        }
    },

    getRootUrl: function(){
        return process.env.ROOT_URL;
    }
});