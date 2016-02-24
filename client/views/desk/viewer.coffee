Template.mirador_viewer.helpers
  widgets: ->
    ActiveWidgets.find()

Template.mirador_viewer.onRendered ->
  $(window).on 'resizestart', (event) ->
    if (event.target == window)
      #_this.saveCurrentWindowSize()
      # TODO: port from viewer.js
      return

  $(window).on 'resizestop', (event) ->
    if (event.target == window)
      #_this.resizeViewer()
      # TODO: port from viewer.js
      return

  #TODO
  #this.alignViewerElements();
  #this.addParsePluginForAnnotorius();
  return

@miradorFunctions = @miradorFunctions || {}
@miradorFunctions = _.extend @miradorFunctions,
  mirador_viewer_loadView: (type, properties) ->
    console.log 'loadView', arguments
    widgetProps =
      type:       type
      width:      miradorWidgetProperties[type].width
      height:     miradorWidgetProperties[type].height

    if miradorWidgetProperties[type]?.extendedData?
      widgetProps = _.extend widgetProps,
        miradorWidgetProperties[type].extendedData()

    widgetProps = _.extend widgetProps, properties

    ActiveWidgets.insert widgetProps

