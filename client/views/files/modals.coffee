### File Upload Modal ###
Template.fileUploadModal.onCreated ->
  @uploadedFileId = new ReactiveVar

Template.fileUploadModal.helpers
  filename: ->
    FileRegistry.findOne(Template.instance().uploadedFileId.get())?.filename
  disabled: ->
    unless Template.instance().uploadedFileId.get() then "disabled"
  
Template.fileUploadModal.events
  'click button[data-action=upload]': (e, tpl) ->
    Media.pickLocalFile {accept: '.pdf'}, (fileId) ->
      tpl.uploadedFileId.set fileId

  'click button[data-action=save]': (e, tpl) ->
    Meteor.call 'saveFileToProject', tpl.uploadedFileId.get(), Session.get('current_project'), tpl.$('textarea[name=description]').val()
    tpl.$("#fileUploadModal").modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

### Copy File Modal ###
Template.copyModal.helpers
  otherProject: ->
    Projects.find { _id: { $ne: Session.get('current_project') } }

Template.copyModal.events
  'click button[data-action=copy]': (e, tpl) ->
    newProject = tpl.$("select[name=project]").val()
    copy = FileCabinet.findOne(@_id, { fields: { _id: 0 } })
    copy.project = newProject
    FileCabinet.insert(copy)
    tpl.$("#copyModal").modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

### Batch Copy File Modal ###
Template.copyBatchModal.helpers
  otherProject: ->
    Projects.find { _id: { $ne: Session.get('current_project') } }

Template.copyBatchModal.events
  "click button[data-action=copy]": (e, tpl) ->
    newProject = tpl.$("select[name=project]").val()
    _.each tpl.data, (i) ->
      i._id = null
      i.project = newProject
      FileCabinet.insert i
    tpl.$("#copyBatchModal").modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

### Confirm Delete Modal ###
Template.confirmDeleteModal.events
  'click button[data-action=delete]': (e, tpl) ->
    Meteor.call "deleteEditorDoc", @_id
    tpl.$("#confirmDeleteModal").modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

### Confirm Batch Delete Modal ###
Template.confirmBatchDeleteModal.events
  'click button[data-action=delete]': (e, tpl) ->
    _.each tpl.data, (i) ->
      Meteor.call "deleteEditorDoc", i._id
    tpl.$("#confirmBatchDeleteModal").modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view
