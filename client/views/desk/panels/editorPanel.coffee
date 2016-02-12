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


