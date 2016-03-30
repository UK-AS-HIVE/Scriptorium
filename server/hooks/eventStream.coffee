_.each [ AvailableManifests, DeskSnapshots, Annotations, FileCabinet ], (c) ->
  c.after.insert (userId, doc) ->
    fullName = User.first(userId).fullName()
    message = switch c._name
      when 'availablemanifests'
        "<strong>#{fullName}</strong> added manifest <strong>#{doc.manifestTitle}</strong>."
      when 'deskSnapshots'
        "<strong>#{fullName}</strong> created snapshot <strong>#{doc.title}</strong>."
      when 'annotations'
        image = AvailableManifests.findOne(doc.manifestId)?.manifestPayload.sequences[0].canvases[doc.canvasIndex].label
        manifest = AvailableManifests.findOne(doc.manifestId)?.manifestTitle
        "<strong>#{fullName}</strong> annotated <strong>#{image}</strong> in manifest <strong>#{manifest}</strong>."
      when 'filecabinet'
        if doc.fileType is 'upload'
          "<strong>#{fullName}</strong> uploaded file <strong>#{doc.title}</strong>."
        else
          "<strong>#{fullName}</strong> created editor document <strong>#{doc.title}</strong>."

    EventStream.insert
      projectId: doc.projectId || doc.project
      type: c._name
      userId: userId
      timestamp: new Date()
      otherId: doc._id
      message: message

Projects.after.update (userId, doc, fn, modifier, options) ->
  if 'permissions' in fn and modifier.$addToSet?
    message = "User <strong>#{User.first(userId).fullName()}</strong> added user
      <strong>#{User.first(modifier.$addToSet.permissions.user).fullName()}</strong> to the project."
    EventStream.insert
      projectId: doc._id
      type: 'project'
      userId: userId
      timestamp: new Date()
      message: message
      otherId: modifier.$addToSet.permissions.user
