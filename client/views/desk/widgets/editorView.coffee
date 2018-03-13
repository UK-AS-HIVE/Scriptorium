@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.editorView =
  title: ->
    'Editor View: ' + FileCabinet.findOne(@fileCabinetId).title
  height: 400
  width: 600
  contentClass: "mirador-widget-content-editor-view"
  toolbarHeight: 0
  statusbarHeight: 0

### EDITOR VIEW STATUSBAR ###
Template.mirador_editorView_statusbar.onCreated ->
  @saved = new ReactiveVar(false)

Template.mirador_editorView_statusbar.onRendered ->
  tpl = @
  tpl.find('.saved-file-container')?._uihooks =
    insertElement: (node, next) ->
      $(node).hide().insertBefore(next).fadeIn(100).delay(3000).fadeOut 500, ->
        @remove()
        tpl.saved.set false

Template.mirador_editorView_statusbar.events
  'click button[data-action=save]': (e, tpl) ->
    # TODO: If widget templates are combined, getting content via tpl.$('.cke_wysiwyg_div') is probably more reliable
    tpl.saved.set 'saving'
    Meteor.call 'updateAndUnlockEditorFile', @fileCabinetId, FileCabinet.findOne(@fileCabinetId).editVersion, CKEDITOR.instances["editor-#{@fileCabinetId}"].getData(), (err, res) ->
      tpl.saved.set 'saved'

Template.mirador_editorView_statusbar.helpers
  disabled: ->
    # TODO: Use the locked ReactiveVar when widget templates are more reasonable
    file = FileCabinet.findOne(@fileCabinetId)
    if file?.editorLockedByUserId? and (file?.editorLockedByUserId isnt Meteor.userId() or file?.editorLockedByConnectionId isnt Meteor.connection._lastSessionId)
      "disabled"
  locked: ->
    # TODO: Use the locked ReactiveVar when widget templates are more reasonable
    file = FileCabinet.findOne(@fileCabinetId)
    file?.editorLockedByUserId? and (file?.editorLockedByUserId isnt Meteor.userId() or file?.editorLockedByConnectionId isnt Meteor.connection._lastSessionId)
  lockedByCurrentUser: ->
    file = FileCabinet.findOne(@fileCabinetId)
    file?.editorLockedByUserId is Meteor.userId() and file?.editorLockedByConnectionId is Meteor.connection._lastSessionId
  owner: ->
    User.first(FileCabinet.findOne(@fileCabinetId)?.editorLockedByUserId).fullName()
  saved: -> Template.instance().saved.get() == 'saved'
  saving: -> Template.instance().saved.get() == 'saving'
  fileIsType: (type) ->
    fileName = FileCabinet.findOne(@fileCabinetId)?.title
    ext = fileName.substr(fileName.lastIndexOf('.') + 1)
    return ext is type
  editVersion: ->
    FileCabinet.findOne(@fileCabinetId)?.editVersion

Template.editorView_content_editor.onDestroyed ->
  @observeHandle.stop()

### EDITOR VIEW CONTENT ###
Template.editorView_content_editor.onRendered ->
  @editor = CKEDITOR.replace "editor-" + @data.fileCabinetId, {
    customConfig: '/plugins/ckeditor/custom.js'
  }

  # HACK: calling editor.resize after instantiation throws an error.
  # This ensures we wait 500ms before the first call...
  ready = new ReactiveVar(false)
  Meteor.setTimeout ->
    ready.set true
    @.$('.cke_wysiwyg_div').focus()
  , 500

  @autorun =>
    if ready.get()
      @editor.resize Template.currentData().width-2, Template.currentData().height-75

  @locked = new ReactiveVar(false)

  highestEditRevision = 0

  @observeHandle = FileCabinet.find(@data.fileCabinetId).observe
    changed: (newDoc) =>
      if newDoc.editVersion > highestEditRevision
        highestEditRevision = newDoc.editVersion
        if newDoc.lastEditConnectionId isnt Meteor.connection._lastSessionId
          @.$('.cke_wysiwyg_div').html newDoc.content

  @autorun =>
    file = FileCabinet.findOne(@data.fileCabinetId, { fields: { 'editorLockedByUserId': 1, 'editorLockedByConnectionId': 1 } })
    @locked.set file?.editorLockedByUserId? and (
      file?.editorLockedByUserId isnt Meteor.userId() or
      (file?.editorLockedByConnectionId? and file?.editorLockedByConnectionId isnt Meteor.connection._lastSessionId)
    )

    if ready.get()
      @.$('.cke_wysiwyg_div').prop 'contenteditable', !@locked.get()

  @editor.on 'change', =>
    unless @locked.get()
      Meteor.call 'updateEditorFile', @data.fileCabinetId, FileCabinet.findOne(@data.fileCabinetId).editVersion, @.$('.cke_wysiwyg_div').html()

Template.mirador_editorView_content.helpers
  fileIsEditor: ->
    FileCabinet.findOne(@fileCabinetId)?.fileType is 'editor'

Template.mirador_editorView_statusbar.helpers
  fileIsEditor: ->
    FileCabinet.findOne(@fileCabinetId)?.fileType is 'editor'

Template.editorView_content_editor.helpers
  content: ->
    FileCabinet.findOne(@fileCabinetId)?.content

Template.editorView_content_pdf.helpers
  filename: ->
    fr = FileCabinet.findOne({'_id': @fileCabinetId}).fileRegistryId
    FileRegistry.findOne(fr)?.filenameOnDisk
