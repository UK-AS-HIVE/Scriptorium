# TODO: Purpose of these is just wrappers to display content - need to handle resizing on them and choosing what templates to render
#

Template.mirador_widget_initialLayout.onRendered ->
  options =
    appendTo:             '.mirador-viewer'
    autoOpen:             true
    containerCls:         '.mirador-viewer'
    closeOnEscape:        false
    content:              null
    draggable:            true
    element:              null
    height:               400 #$.DEFAULT_SETTINGS.widget.height
    id:                   null
    metadataDetails:      null
    openAt:               null
    showStatusbar:        true
    showToolbar:          true
    statusbar:            null
    toolbar:              null
    type:                 'thumbnailsView'
    viewObj:              null
    widgetCls:            'mirador-widget'
    widgetContentCls:     'mirador-widget-content'
    widgetStatusbarCls:   'mirador-widget-statusbar'
    widgetToolbarCls:     'mirador-widget-toolbar'
    width:                350 #$.DEFAULT_SETTINGS.widget.width
    position:
      'my': 'left top'
      'at': 'left+50 top+50'
      'of': '.mirador-viewer'
      'collision' : 'fit'
      'within' : '.mirador-viewer'
    dialogOptions:
      'resize': (event, ui) -> {}
      'resizeStop': (event, ui) -> {}
      'close': (event, ui) -> {}
    dialogExtendOptions:
      'maximizable': true
      'collapsable': true
      'icons':
        'maximize': 'ui-icon-arrow-4-diag'
        'collapse': 'ui-icon-minus'
      # limit maximized widget height to not hide main menu and status bar
      #'mainMenuHeight': $.viewer.mainMenu.element.outerHeight(true) + 84, # the plus 84 accounts for the scriptorium header
      #'statusBarHeight': $.viewer.statusBar.element.outerHeight(true)

  console.log 'Initializing jQuery-UI dialog, resizable, and draggable on widget', @

  @.$('.mirador-widget')
    #.addClass(this.widgetCls)
    #.attr('id', this.id)
    #.attr('title', this.getTitle())
    #.attr('title', 'Testing!')
    #.appendTo(options.appendTo)
    #.dialog(this)
    #.dialog(this.dialogOptions)
    #.dialogExtend(this.dialogExtendOptions)
    #.dialog('option', 'id', this.id)
    .dialog(options)

    # Settings that will execute when resized.
    .parent().resizable
      containment: '.mirador-viewer' # Constrains the resizing to the div.

    # Settings that execute when the dialog is dragged. If parent isn't used the text content will have dragging enabled.
    .draggable
      containment: '.mirador-viewer' # The element the dialog is constrained to.

Template.mirador_widget_toolbar.helpers
  hidden: ->
    if !@showToolbar
      "display: none;"
  template: ->
    console.log 'calculating template name for widget toolbar: ', @
    'mirador_' + @type + '_navToolbar'
  height: -> @height

Template.mirador_widget_statusbar.helpers
  hidden: ->
    if !@showToolbar
      "display: none;"
  template: ->
    'mirador_' + @type + '_statusbar'
  height: -> @height

Template.mirador_widget_content.helpers
  height: ->
    # TODO: Mirador pulls the height for this element from widget - statusbar - toolbar
    @height
  template: ->
    'mirador_' + @type + '_content'

