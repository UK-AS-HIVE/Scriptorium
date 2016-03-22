_.each [ AvailableManifests, DeskSnapshots, Annotations, FileCabinet ], (c) ->
  c.after.insert (userId, doc) ->
    EventStream.insert
      projectId: doc.projectId || doc.project
      type: c._name
      userId: userId
      timestamp: new Date()
      otherId: doc._id

Projects.after.update (userId, doc, fn, modifier, options) ->
  if 'permissions' in fn and modifier.$addToSet?
    EventStream.insert
      projectId: doc._id
      type: 'user'
      userId: userId
      timestamp: new Date()
      otherId: modifier.$addToSet.permissions.user

