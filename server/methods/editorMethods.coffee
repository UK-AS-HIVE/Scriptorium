Meteor.methods
  saveEditorDoc: (editorData) ->
    console.log(editorData)

  getNewEditorId: (user, project, title, desc) ->
    console.log("new editor instance requested")
    newEditorID = FileCabinet.insert
      project: project
      fileType: 'editor'
      user: user
      date: new Date()
      content: ""
      open: true
      title: title
      description: desc

    return newEditorID
