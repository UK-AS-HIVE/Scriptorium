Template.desk.rendered = ->
  #SEO Page Title & Description
  document.title = "Scriptorium - Desk"

Template.desk.events

  "click #addManiButton": ->
    Meteor.call("getManifest", $("#newManifestURL").val(), $("#newManifestLocation").val(), $("#newManifestTitle").val(), Meteor.userId(), Session.get("current_project"))
    $("#addManifestModal").modal('hide')
    console.log "foo"

  "click #docSavedOk": ->
    console.log "saved"
    $("#docSavedModal").modal('hide')

  "click #deleteOk": ->
    Meteor.call("deleteEditorDoc", Session.get "fc_file_to_del")
    Session.set "fc_file_to_del", ""
    $("#confirmDeletePanel").modal('hide')

  "click #deleteCancel": ->
    $("#confirmDeletePanel").modal('hide')
