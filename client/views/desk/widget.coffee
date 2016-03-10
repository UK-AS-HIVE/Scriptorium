# TODO: Purpose of these is just wrappers to display content - need to handle resizing on them and choosing what templates to render
#

# Disable conflicts with bootstrap, so that dialog close buttons appear correctly
Meteor.startup ->
  jQuery.fn.button.noConflict()

miradorWidgetProperties = @miradorWidgetProperties = @miradorWidgetProperties || {}

Template.mirador_widget_initialLayout.helpers
  widgetId: -> @_id

lastWidgetOffset = 0

getWidgetPosition = (widgetData) ->
  if widgetData.x?
    return "left+#{widgetData.x} top+#{widgetData.y}"
  else
    DeskWidgets.update widgetData._id,
      $set:
        x: lastWidgetOffset
        y: lastWidgetOffset
    wp = "left+#{lastWidgetOffset} top+#{lastWidgetOffset}"
    lastWidgetOffset = lastWidgetOffset + 25
    return wp


Template.mirador_widget_initialLayout.onRendered ->
  console.log 'mirador_widget_initialLayout.onRendered'
  widget = @
  widgetId = @data._id

  options =
    appendTo:             '.mirador-viewer'
    autoOpen:             true
    containerCls:         '.mirador-viewer'
    closeOnEscape:        false
    content:              null
    draggable:            true
    element:              null
    height:               @data.height
    id:                   null
    metadataDetails:      null
    openAt:               null
    showStatusbar:        true
    showToolbar:          true
    statusbar:            null
    toolbar:              null
    type:                 @data.type
    viewObj:              null
    widgetCls:            'mirador-widget'
    widgetContentCls:     'mirador-widget-content'
    widgetStatusbarCls:   'mirador-widget-statusbar'
    widgetToolbarCls:     'mirador-widget-toolbar'
    width:                @data.width
    position:
      'my': 'left top'
      'at': getWidgetPosition @data
      'of': '.mirador-viewer'
      'collision' : 'fit'
      'within' : '.mirador-viewer'
    dialogOptions:
      'resize': (event, ui) ->
        DeskWidgets.update widgetId,
          $set:
            x: ui.position.left
            y: ui.position.top
            width: ui.size.width
            height: ui.size.height
      'resizeStop': (event, ui) -> {}
      'close': (event, ui) ->
        $(this).dialog('destroy').remove()
        DeskWidgets.remove widgetId
    dialogExtendOptions:
      'maximizable': true
      'maximize': (e, ui) ->
        DeskWidgets.update widgetId,
          $set:
            width: ui.size.width
            height: ui.size.height
      'maximizeRestore': (e, ui) ->
        DeskWidgets.update widgetId,
          $set:
            width: ui.size.width
            height: ui.size.height

      'collapsable': true
      'icons':
        'maximize': 'ui-icon-arrow-4-diag'
        'collapse': 'ui-icon-minus'
      # limit maximized widget height to not hide main menu and status bar
      #'mainMenuHeight': $.viewer.mainMenu.element.outerHeight(true) + 84, # the plus 84 accounts for the scriptorium header
      #'statusBarHeight': $.viewer.statusBar.element.outerHeight(true)

  @.$('.mirador-widget')
    #.addClass(this.widgetCls)
    #.attr('id', this.id)
    #.attr('title', this.getTitle())
    #.attr('title', 'Testing!')
    #.appendTo(options.appendTo)
    #.dialog(this)
    #.dialog(this.dialogOptions)
    #.dialog('option', 'id', this.id)
    .dialog(options)
    .dialog(options.dialogOptions)
    .dialogExtend(options.dialogExtendOptions)

    # Settings that will execute when resized.
    .parent().resizable
      containment: '.mirador-viewer' # Constrains the resizing to the div.

    # Settings that execute when the dialog is dragged. If parent isn't used the text content will have dragging enabled.
    .draggable
      containment: '.mirador-viewer' # The element the dialog is constrained to.
      drag: (event, ui) -> {}
      start: (event, ui) -> {}
      stop: (event, ui) ->
        DeskWidgets.update widgetId,
          $set:
            x: ui.position.left
            y: ui.position.top


  @autorun ->
    w = $("##{widgetId}")
    d = Template.currentData()
    w.dialog 'option', 'title', miradorWidgetProperties[d.type]?.title.call(d)
    w.dialog 'option', 'position',
      'my': 'left top'
      'at': "left+#{d.x} top+#{d.y}"
      'of': '.mirador-viewer'
      'collision': 'fit'
      'within': '.mirador-viewer'
    w.dialog 'option', 'width', d.width
    w.dialog 'option', 'height', d.height

Template.mirador_widget_toolbar.helpers
  hidden: ->
    if @hidden
      "display: none;"
    else
      "display: block;"
  template: ->
    'mirador_' + @type + '_navToolbar'
  height: ->
    # TODO: real calculations here
    100

Template.mirador_widget_statusbar.helpers
  hidden: ->
    if @hidden
      "display: none;"
    else
      "display: block;"
  template: ->
    'mirador_' + @type + '_statusbar'
  height: -> 100 #@height

Template.mirador_widget_content.helpers
  height: ->
    # TODO: figure out constant pixel offset
    @height - 100
  template: ->
    'mirador_' + @type + '_content'
  contentClass: ->
    miradorWidgetProperties[@type]?.contentClass

