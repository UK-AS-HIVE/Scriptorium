Template.mirador_viewer.events
  'focusin .ui-widget': (e, tpl) ->
    # Blaze.getData wont work on the currentTarget since Blaze didnt create it;
    # so, we get the ID from the child mirador-widget.
    # We could alternately get this ID from the aria-describedby attribute on the currentTarget
    widgetId = tpl.$(e.currentTarget).children('.mirador-widget').attr('id')
    maxWidget = DeskWidgets.findOne {}, { sort: { order: -1 } }
    if maxWidget._id isnt widgetId
      order = maxWidget.order || 0
      DeskWidgets.update widgetId, { $set: { order: order + 1 } }

Template.mirador_viewer.helpers
  widgets: ->
    # Sort by ascending order so we'll render bottom to top.
    DeskWidgets.find { projectId: Session.get('current_project') }, { sort: { order: 1 } }

@miradorFunctions = @miradorFunctions || {}
@miradorFunctions = _.extend @miradorFunctions,
  mirador_viewer_loadView: (type, properties) ->
    console.log 'loadView', arguments
    widgetProps =
      userId:     Meteor.userId()
      projectId:  Session.get('current_project')
      type:       type
      width:      miradorWidgetProperties[type].width
      height:     miradorWidgetProperties[type].height

    if miradorWidgetProperties[type]?.extendedData?
      widgetProps = _.extend widgetProps,
        miradorWidgetProperties[type].extendedData()

    widgetProps = _.extend widgetProps, properties

    DeskWidgets.insert widgetProps

