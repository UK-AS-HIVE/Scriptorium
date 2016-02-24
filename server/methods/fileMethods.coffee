Meteor.methods

  deleteEditorDoc: (fileToDelete) ->
    file = FileCabinet.findOne({'_id': fileToDelete})
    if file.fileType == 'upload'
      #kill the file in the file system maybe?
      console.log fileToDelete
    FileCabinet.remove({"_id": fileToDelete})

  saveFileToProject: (fileId, project, desc) ->
    file = FileRegistry.findOne(fileId)
    FileCabinet.insert
      'project': project
      'fileType': 'upload'
      'user': @userId
      'date': new Date()
      'content': fileId
      'open': false
      'title': file.filename
      'description': desc
