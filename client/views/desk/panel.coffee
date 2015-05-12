Template.deskPanel.events

  "click .js-close-panel": ->
    $('.desk-document-panel').removeClass('is-open');

  "click .editorItem": ->
    console.log this
    FileCabinet.update({'_id': this._id}, {$set: {'open': true}})

Template.deskPanel.helpers
  documents: ->
    FileCabinet.find({'project': Session.get('current_project')})

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

Template.newDocPanel.events
  "click .js-close-panel": ->
    $('.desk-new-doc-panel').removeClass('is-open')

Template.editorPanel.rendered = ->
  console.log "rendered: " + this.data.eId
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
    console.log "close" + JSON.stringify(this)
    FileCabinet.update({'_id': this.eId}, {$set: {'open': false}})

  "click .editor-save": ->
    console.log this
    FileCabinet.update({'_id': this.eId}, {$set: {'content': CKEDITOR.instances["editor-" + this.eId].getData()}})

Template.newDocPanel.events
  "click #saveAsDocument": ->
    console.log "clicked save"
    Meteor.call("getNewEditorId", Meteor.userId(), Session.get('current_project'), $("#newDocName").val())