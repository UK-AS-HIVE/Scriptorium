Meteor.methods
  getManifest: (url, location, title, project) ->
    try
      res = HTTP.get url
      if res.statusCode is 200
        AvailableManifests.insert
          user: @userId
          project: project
          manifestPayload: JSON.parse(res.content)
          manifestLocation: location
          manifestTitle: title
    catch e
      throw new Meteor.Error(e.message)

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

