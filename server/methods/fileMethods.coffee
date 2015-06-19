Meteor.methods({

  deleteEditorDoc: (fileToDelete) ->
    isOpen = OpenDocs.findOne({"document": fileToDelete})
    if isOpen?
      OpenDocs.remove({"_id": isOpen["_id"]})
    FileCabinet.remove({"_id": fileToDelete})

})