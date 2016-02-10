Meteor.methods
  getManifest: (URL, location, title, user, project) ->
    HTTP.get URL, (err, result) ->
      if result.statusCode is 200
        AvailableManifests.insert
          user: user
          project: project
          manifestPayload: JSON.parse(result.content)
          manifestLocation: location
          manifestTitle: title

  shareManifests: (user, newProject, sharedManifest, widgets) ->
    newManifest = AvailableManifests.insert
      user: user
      project: newProject
      manifestPayload: sharedManifest.payload
      manifestLocation: sharedManifest.location
      manifestTitle: sharedManifest.title

    return {
      id: newManifest
      widgets: widgets
      project: newProject
    }

  addDataToProject: (projectId, manifestId, widgets) ->
    manifestData = {
      manifestId: manifestId,
      widgets: widgets
    }
    Projects.update projectId, { $push: { "miradorData": manifestData } }

  saveWorkSpace: (workspace, user, project) ->
    workspaceJSON = JSON.parse(workspace)
    i = 0
    while i < workspaceJSON.data.length
      Workspaces.upsert {
        user: user
        project: project
        manifestUri: workspaceJSON.data[i].manifestUri
      }, { $set: { widgets: workspaceJSON.data[i].widgets } }
      i++

  getRootUrl: ->
    process.env.ROOT_URL
