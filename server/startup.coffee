Meteor.startup ->
  AvailableManifests.remove({})
  FileCabinet.remove({})
  OpenDocs.remove({})
  Projects.remove({})
  Annotations.remove({})
  ProjectPermissions.remove({})
  Workspaces.remove({})
  Messages.remove({})

  if AvailableManifests.find().count() == 0
    Meteor.call("getManifest", "http://loris.as.uky.edu/manifests/folio/manifest.json", "HMML", "Folio", "Default", "Default")
    Meteor.call("getManifest", "http://loris.as.uky.edu/manifests/Canones_Apostolorum.json", "UK", "Canones_Apostolorum", "Default", "Default")