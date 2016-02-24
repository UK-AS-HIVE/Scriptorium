Template.documentPanel.events

  "click .js-close-panel": ->
    $('.desk-document-panel').removeClass('is-open')

  "click .editorItem": ->
    miradorFunctions.mirador_viewer_loadView "editorView",
      fileCabinetId: @_id

  "click .doc-panel-delete": ->
    Session.set "fc_file_to_del", this._id
    $("#confirmDeletePanel").modal('show')

Template.documentPanel.helpers
  documents: ->
    FileCabinet.find { project: Session.get('current_project') }

  isOpen: ->
    false


