Meteor.methods
  saveDeskSnapshot: (projectId, title, description) ->
    console.log 'saveDeskSnapshot', projectId, title, description
    DeskSnapshots.insert
      projectId: projectId
      userId: @userId
      title: title
      description: description
      timestamp: new Date()
      widgets: DeskWidgets.find({projectId: projectId, userId: @userId}).map (w) ->
        delete w._id
        delete w.projectId
        delete w.userId
        return w

  loadDeskSnapshot: (snapshotId) ->
    snapshot = DeskSnapshots.findOne snapshotId

    DeskWidgets.remove
      projectId: snapshot.projectId
      userId: @userId

    _.each snapshot.widgets, (w) =>
      DeskWidgets.insert _.extend w,
        projectId: snapshot.projectId
        userId: @userId

