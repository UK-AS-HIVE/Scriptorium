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
  tpl.find('.editor-view-statusbar')._uihooks =
    insertElement: (node, next) ->
      $(node).hide().insertBefore(next).fadeIn(100).delay(3000).fadeOut 500, ->
        @remove()
        tpl.saved.set false

Template.mirador_editorView_statusbar.events
  'click button[data-action=save]': (e, tpl) ->
    FileCabinet.update @fileCabinetId, { $set: { content: CKEDITOR.instances["editor-" + @fileCabinetId].getData() } }
    tpl.saved.set true

Template.mirador_editorView_statusbar.helpers
  saved: -> Template.instance().saved.get()

### EDITOR VIEW CONTENT ###
Template.mirador_editorView_content.onRendered ->
  @editor = CKEDITOR.replace("editor-" + @data.fileCabinetId)
  # HACK: calling editor.resize after instantiation throws an error.
  # This ensures we wait 200ms before the first call...
  ready = new ReactiveVar(false)
  Meteor.setTimeout ->
    ready.set true
  , 200
  @autorun =>
    if ready.get()
      @editor.resize Template.currentData().width-2, Template.currentData().height-75

Template.mirador_editorView_content.onDestroyed ->
  # TODO: onDestroyed doesn't get called :(
  console.log 'ondestroyed'
  Meteor.call "closeDoc", Meteor.userId(), Session.get('current_project'), @data.fileCabinetId
  @editor?.destroy()

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

