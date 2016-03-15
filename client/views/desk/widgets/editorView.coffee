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
  tpl.find('.saved-file-container')._uihooks =
    insertElement: (node, next) ->
        $(node).hide().insertBefore(next).fadeIn(100).delay(3000).fadeOut 500, ->
          @remove()
          tpl.saved.set false

Template.mirador_editorView_statusbar.events
  'click button[data-action=save]': (e, tpl) ->
    FileCabinet.update @fileCabinetId, { $set: { content: CKEDITOR.instances["editor-" + @fileCabinetId].getData() } }
    tpl.saved.set true

Template.mirador_editorView_statusbar.helpers
  disabled: ->
    # TODO: Use the locked ReactiveVar when widget templates are more reasonable
    editorLockedBy = FileCabinet.findOne(@fileCabinetId)?.editorLockedBy
    if editorLockedBy? and editorLockedBy isnt Meteor.userId() then "disabled"
  locked: ->
    # TODO: Use the locked ReactiveVar when widget templates are more reasonable
    editorLockedBy = FileCabinet.findOne(@fileCabinetId)?.editorLockedBy
    editorLockedBy? and editorLockedBy isnt Meteor.userId()
  owner: -> User.first(@editorLockedBy).fullName()
  saved: -> Template.instance().saved.get()
  fileIsType: (type) ->
    fileName = FileCabinet.findOne(@fileCabinetId)?.title
    ext = fileName.substr(fileName.lastIndexOf('.') + 1)
    return ext is type

### EDITOR VIEW CONTENT ###
Template.mirador_editorView_content.onRendered ->
  @editor = CKEDITOR.replace "editor-" + @data.fileCabinetId, {
    customConfig: '/plugins/ckeditor/custom.js'
  }
  # HACK: calling editor.resize after instantiation throws an error.
  # This ensures we wait 500ms before the first call...
  ready = new ReactiveVar(false)
  Meteor.setTimeout ->
    ready.set true
  , 500

  @autorun =>
    if ready.get()
      @editor.resize Template.currentData().width-2, Template.currentData().height-75

  @locked = new ReactiveVar(false)

  @autorun =>
    lockedBy = FileCabinet.findOne(@data.fileCabinetId, { fields: { 'editorLockedBy': 1 , 'lastEdit': 1} })?.editorLockedBy
    @locked.set lockedBy? and lockedBy isnt Meteor.userId()
    if ready.get()
      @.$('.cke_wysiwyg_div').prop 'contenteditable', !@locked.get()

  @autorun =>
    if @locked.get()
      @.$('.cke_wysiwyg_div').html FileCabinet.findOne({ _id: @data.fileCabinetId }, { fields: { 'content': 1 } })?.content


Template.mirador_editorView_content.helpers
  editorId: ->
    @fileCabinetId
  content: ->
    FileCabinet.findOne(@fileCabinetId)?.content
  fileIsType: (type) ->
    fileName = FileCabinet.findOne(@fileCabinetId)?.title
    ext = fileName.substr(fileName.lastIndexOf('.') + 1)
    return ext is type
  getFileName: ->
    content = FileCabinet.findOne({'_id': @fileCabinetId}).content
    return FileRegistry.findOne("_id": content)?.filenameOnDisk

Template.mirador_editorView_content.events
  'keyup .cke_wysiwyg_div': (e, tpl) ->
    unless tpl.locked.get()
      FileCabinet.update tpl.data.fileCabinetId, { $set: { content: tpl.$('.cke_wysiwyg_div').html() } }

