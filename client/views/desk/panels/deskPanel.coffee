Template.deskPanel.events

  "click .js-close-panel": ->
    $('.desk-document-panel').removeClass('is-open')

  "click .editorItem": ->
    Meteor.call("openDoc", Meteor.userId(), Session.get('current_project'), this._id)

  "click .doc-panel-delete": ->
    Session.set "fc_file_to_del", this._id
    $("#confirmDeletePanel").modal('show')

Template.deskPanel.helpers
  documents: ->
    FileCabinet.find({'project': Session.get('current_project')})

  isOpen: ->
    docArray = OpenDocs.findOne({'user': Meteor.userId(), 'project': Session.get('current_project'), 'document': this['_id']})
    if docArray.length != 0
      true
    else
      false


