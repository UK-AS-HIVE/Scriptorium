Template.files.helpers
  areFiles: ->
    projectFiles = FileCabinet.find({'project': Session.get('current_project')}).fetch()
    if projectFiles.length != 0
      true
    else
      false

  docAuthor: ->
    author = Meteor.users.findOne({_id: this.user}).profile
    author.firstName + " " + author.lastName

  files: ->
    FileCabinet.find({'project': Session.get('current_project')})


Template.files.events

  "click .delete": ->
    console.log this
    Session.set "fc_file_to_del", this._id
    $("#confirmDelete").modal('show')

  "click #deleteOk": ->
    console.log Session.get "fc_file_to_del"
    isOpen = OpenDocs.findOne({"document": Session.get "fc_file_to_del"})
    if isOpen?
      OpenDocs.remove({"_id": isOpen["_id"]})
    FileCabinet.remove({"_id": Session.get "fc_file_to_del"})
    $("#confirmDelete").modal('hide')

  "click #deleteCancel": ->
    $("#confirmDelete").modal('hide')