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

Template.savePanel.events

  "click .js-close-panel": ->
    $('.desk-save-panel').removeClass('is-open')

  "click #saveAsProject": ->
    # process -> get new project ID -> share manifests with new project ID -> put new manifest ID's in new project

    if $("#newGroupName").val() != ""

      name = $("#newGroupName").val()
      workspaces = Workspaces.find("user": Meteor.userId(), "project": Session.get("current_project")).fetch()

      # got a new prohect ID
      Meteor.call("saveNewProject", name, Meteor.userId(), workspaces, (err, data) ->

        for space in workspaces
          if space.widgets.length > 0
            uri = space.manifestUri.split("/manifest/")
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
        $('.desk-save-panel').removeClass('is-open')
        Router.go "collaboration"
      )

Template.editorPanel.rendered = ->
  console.log(this.data.eId)
  console.log("resizing viewer")
  $("#viewer-"+this.data.eId).height($("#editorWindow-"+this.data.eId).height()-60)

  myId = "#editorWindow-" + this.data.eId
  eId = this.data.eId
  $(myId).draggable({
    handle: ".ui-dialog-titlebar"
    })
  $(myId).resizable({
    resize: (event, ui) ->
      if (CKEDITOR.instances['editor-' + eId])
        CKEDITOR.instances['editor-' + eId].resize('100%', $(this).height() - 60)
      else if $("#viewer-"+eId)
        $("#viewer-"+eId).height($("#editorWindow-"+eId).height()-60)

  })
  
  CKEDITOR.replace("editor-" + eId)

  
  

Template.editorPanel.helpers
  editorId: ->
    return this.eId
  editorTitle: ->
    record = FileCabinet.findOne({'_id': this.eId})
    record['title']
  content: ->
    record = FileCabinet.findOne({'_id': this.eId})
    record['content']
  fileType: (extension)->
    fileName = FileCabinet.findOne({'_id': this.eId}).title
    ext = fileName.substr(fileName.lastIndexOf('.') + 1)
    if (ext == extension)
      return true
    return false
  getFileName: ->
    content = FileCabinet.findOne({'_id': this.eId}).content
    file = FileRegistry.findOne("_id": content)
    return file.filenameOnDisk
Template.editorPanel.events
  "click .editor-close": ->
    Meteor.call("closeDoc", Meteor.userId(), Session.get('current_project'), this.eId)

  "click .editor-save": ->
    FileCabinet.update({'_id': this.eId}, {$set: {'content': CKEDITOR.instances["editor-" + this.eId].getData()}})
    $('#docSavedModal').modal('show')

  "click #docSavedOk": ->
    console.log "saved"

  "click .cke_toolbox_collapser": (e, tmpl) ->
    eId = tmpl.data.eId
    CKEDITOR.instances['editor-' + eId].resize('100%', $(tmpl.firstNode).height() - 60)

Template.newDocPanel.events

  "click #saveAsDocument": ->
    console.log "clicked save"
    Meteor.call("getNewEditorId", Meteor.userId(), Session.get('current_project'), $("#newDocName").val(), (err, res) ->
      Meteor.call("openDoc", Meteor.userId(), Session.get('current_project'), res)
    )

Template.newDocPanel.events
  "click .js-close-panel": ->
    $('.desk-new-doc-panel').removeClass('is-open')