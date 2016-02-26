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

    return id
