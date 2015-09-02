Meteor.methods({

  deleteEditorDoc: (fileToDelete) ->
    isOpen = OpenDocs.findOne({"document": fileToDelete})
    if isOpen?
      OpenDocs.remove({"_id": isOpen["_id"]})
    FileCabinet.remove({"_id": fileToDelete})

  saveFileToProject: (fileId, user, project) ->
    file = FileRegistry.findOne({"_id": fileId})
    FileCabinet.insert({
      'project': project,
      'fileType': 'upload',
      'user': user,
      'date': new Date(),
      'content': fileId,
      'open': false,
      'title': file.filename
    })

})