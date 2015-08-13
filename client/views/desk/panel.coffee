Template.deskPanel.events

  "click .js-close-panel": ->
    $('.desk-document-panel').removeClass('is-open');

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

Template.savePanel.events

  "click .js-close-panel": ->
    $('.desk-save-panel').removeClass('is-open');

  "click #saveAsProject": ->
    # process -> get new project ID -> share manifests with new project ID -> put new manifest ID's in new project

    if $("#newGroupName").val() != ""

      name = $("#newGroupName").val()
      workspaces = Workspaces.find("user": Meteor.userId(), "project": Session.get("current_project")).fetch()

      # got a new prohect ID
      Meteor.call("saveNewProject", name, Meteor.userId(), workspaces, (err, data) ->

        for space in workspaces
          if space.widgets.length > 0
            uri = space.manifestUri.split("/manifest/");
            id = uri[1].split("/")
            mani = AvailableManifests.findOne({"_id": id[0]})
            newMani = {}
            newMani.location = mani.manifestLocation
            newMani.payload = mani.manifestPayload
            newMani.title = mani.manifestTitle

            Meteor.call("shareManifests", Meteor.userId(), data, newMani, space.widgets, (err, data) ->
              Meteor.call("addDataToProject", data.project, data.id, data.widgets)
            )

        Session.set "current_project", data
        $('.desk-save-panel').removeClass('is-open');
        Router.go "collaboration"
      )

Template.editorPanel.rendered = ->
  myId = "#editorWindow-" + this.data.eId
  $( -> 
    $(myId).draggable()
  )
  CKEDITOR.replace("editor-" + this.data.eId)

Template.editorPanel.helpers
  editorId: ->
    return this.eId
  editorTitle: ->
    record = FileCabinet.findOne({'_id': this.eId})
    record['title']
  content: ->
    record = FileCabinet.findOne({'_id': this.eId})
    record['content']

Template.editorPanel.events
  "click .editor-close": ->
    Meteor.call("closeDoc", Meteor.userId(), Session.get('current_project'), this.eId)

  "click .editor-save": ->
    FileCabinet.update({'_id': this.eId}, {$set: {'content': CKEDITOR.instances["editor-" + this.eId].getData()}})
    $('#docSavedModal').modal('show')

  "click #docSavedOk": ->
    console.log "saved"

Template.newDocPanel.events

  "click #saveAsDocument": ->
    console.log "clicked save"
    Meteor.call("getNewEditorId", Meteor.userId(), Session.get('current_project'), $("#newDocName").val(), (err, res) -> 
      Meteor.call("openDoc", Meteor.userId(), Session.get('current_project'), res)
    )

Template.newDocPanel.events
  "click .js-close-panel": ->
    $('.desk-new-doc-panel').removeClass('is-open')