Template.documentPanel.events
  "click .editorItem": ->
    unless DeskWidgets.findOne({fileCabinetId: @_id})?
      miradorFunctions.mirador_viewer_loadView "editorView",
        fileCabinetId: @_id

  'click span[name=delete]': ->
    Blaze.renderWithData Template.deskConfirmDeleteModal, @, $('body').get(0)
    $("#confirmDeleteModal").modal('show')

  'click span[name=rename]': ->
    Blaze.renderWithData Template.deskRenameModal, @, $('body').get(0)
    $("#deskRenameModal").modal('show')

Template.documentPanel.helpers
  documents: ->
    FileCabinet.find { project: Session.get('current_project') }

  isOpen: ->
    DeskWidgets.findOne({fileCabinetId: @_id})?

  isEditor: ->
    @fileType is 'editor'

  formattedDate: ->
    moment(@date).format('LLL')


