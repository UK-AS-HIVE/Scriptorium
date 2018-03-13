handles = {}
Meteor.methods
  newEditorDoc: (project, title, desc) ->
    id = FileCabinet.insert
      project: project
      fileType: 'editor'
      user: @userId
      date: new Date()
      open: true
      title: title
      description: desc
      editVersion: 0

    return id

  updateEditorFile: (id, currentRev, content) ->
    projectId = FileCabinet.findOne(id, { fields: { 'project': 1 } })?.project
    if Projects.findOne({_id: projectId, $or: [ { personal: @userId }, { 'permissions.user': @userId } ] })?

      FileCabinet.update {_id: id, editVersion: currentRev}, { $inc: {editVersion: 1}, $set: { content: content, lastEditConnectionId: @connection?.id, editorLockedByUserId: @userId, editorLockedByConnectionId: @connection?.id } }
      title = FileCabinet.findOne(id, { fields: {'title':1 } }).title

      if handles[id] then Meteor.clearTimeout handles[id]
      handles[id] = Meteor.setTimeout =>
        FileCabinet.update {_id: id}, {$set: { editorLockedByUserId: null, editorLockedByConnectionId: null } }
        EventStream.insert
          type: "filecabinet"
          projectId: projectId
          userId: @userId
          timestamp: new Date()
          otherId: id
          message: "User <strong>#{User.first(@userId).fullName()}</strong> edited document <strong>#{title}</strong>."
      , 30000

  updateAndUnlockEditorFile: (id, currentRev, content) ->
    if FileCabinet.findOne { _id: id, editVersion: currentRev, editorLockedByUserId: @userId }
      if handles[id] then Meteor.clearTimeout handles[id]
      FileCabinet.update {_id: id, editVersion: currentRev}, { $inc: {editVersion: 1}, $set: { content: content, lastEditConnectionId: @connection?.id, editorLockedByUserId: null, editorLockedByConnectionId: null } }
      title = FileCabinet.findOne(id, { fields: {'title':1 } }).title
      projectId = FileCabinet.findOne(id, { fields: { 'project': 1 } })?.project
      EventStream.insert
        type: "filecabinet"
        projectId: projectId
        userId: @userId
        timestamp: new Date()
        otherId: id
        message: "User <strong>#{User.first(@userId).fullName()}</strong> edited document <strong>#{title}</strong>."
