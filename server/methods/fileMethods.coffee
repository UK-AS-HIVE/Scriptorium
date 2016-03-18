Meteor.methods
  deleteEditorDoc: (fileToDelete) ->
    file = FileCabinet.findOne({'_id': fileToDelete})
    if file.fileType == 'upload'
      #kill the file in the file system maybe?
      console.log fileToDelete
    lockedUser = FileCabinet.findOne(fileToDelete).editorLockedByUserId
    if lockedUser?
      throw new Meteor.Error "This file is currently locked for editing by #{User.first(lockedUser).fullName()}. Please wait for them to finish editing before deleting."

    FileCabinet.remove { _id: fileToDelete }
    DeskWidgets.remove { fileCabinetId: fileToDelete }


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
