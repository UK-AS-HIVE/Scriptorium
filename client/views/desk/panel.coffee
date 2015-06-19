Template.deskPanel.events

  "click .js-close-panel": ->
    $('.desk-document-panel').removeClass('is-open');

  "click .editorItem": ->
    console.log this
    # FileCabinet.update({'_id': this._id}, {$set: {'open': true}})
    Meteor.call("openDoc", Meteor.userId(), Session.get('current_project'), this._id)

  "click .doc-panel-delete": ->
    Session.set "fc_file_to_del", this._id
    $("#confirmDeletePanel").modal('show') 

Template.deskPanel.helpers
  documents: ->
    FileCabinet.find({'project': Session.get('current_project')})

  isOpen: ->
    console.log "isOpen " + this
    docArray = OpenDocs.findOne({'user': Meteor.userId(), 'project': Session.get('current_project'), 'document': this['_id']})
    if docArray.length != 0
      true
    else
      false

Template.savePanel.events

  "click .js-close-panel": ->
    $('.desk-save-panel').removeClass('is-open');

  "click #saveAsProject": ->
    if $("#newGroupName").val() != ""

      name = $("#newGroupName").val()
      workspaces = Workspaces.find("user": Meteor.userId(), "project": Session.get("current_project")).fetch()

      Meteor.call("saveNewProject", name, Meteor.userId(), workspaces, (err, data) ->
        Session.set "current_project", data
        $('.desk-save-panel').removeClass('is-open');
        Router.go "collaboration"
      )

Template.editorPanel.rendered = ->
  console.log "rendered: " + this.data.eId
  myId = "#editorWindow-" + this.data.eId
  $( -> 
    $(myId).draggable()
  )
  CKEDITOR.replace("editor-" + this.data.eId)

Template.editorPanel.helpers
  editorId: ->
    console.log this
    return this.eId
  editorTitle: ->
    record = FileCabinet.findOne({'_id': this.eId})
    record['title']
  content: ->
    record = FileCabinet.findOne({'_id': this.eId})
    record['content']

Template.editorPanel.events
  "click .editor-close": ->
    console.log "close" + JSON.stringify(this)
    Meteor.call("closeDoc", Meteor.userId(), Session.get('current_project'), this.eId)

  "click .editor-save": ->
    console.log this
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