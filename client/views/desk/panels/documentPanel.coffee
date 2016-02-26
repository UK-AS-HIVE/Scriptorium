Template.documentPanel.events
  "click .js-close-panel": ->
    $('.desk-document-panel').removeClass('is-open')

  "click .editorItem": ->
    unless ActiveWidgets.findOne({fileCabinetId: @_id})?
      miradorFunctions.mirador_viewer_loadView "editorView",
        fileCabinetId: @_id

  'click span[name=delete]': ->
    Blaze.renderWithData Template.deskConfirmDeleteModal, @, $('body').get(0)
    $("#confirmDeleteModal").modal('show')

Template.documentPanel.helpers
  documents: ->
    # TODO: If Annotations are going to be their own collection, the fileType selector here is irrelevant.
    FileCabinet.find { project: Session.get('current_project') , fileType: { $in: [ 'editor', 'upload' ] } }

  isOpen: ->
    ActiveWidgets.findOne({fileCabinetId: @_id})?

  isEditor: ->
    @fileType is 'editor'


