
Template.annotationEditTooltip.helpers
  reactiveAnnotation: ->
    Annotations.findOne @_id
  selectedIf: (type) ->
    if @type == type then 'selected'

Template.annotationEditTooltip.events
  'click button[data-action=save-annotation]': (e, tpl) ->
    Annotations.update tpl.data._id,
      $set:
        text: CKEDITOR.instances["editor-#{tpl.data._id}"].getData()
  'click button[data-action=delete-annotation]': (e, tpl) ->
    Annotations.remove @_id
  'click .close-anno-tooltip': (e, tpl) ->
    div = $('<div/>')
    Blaze.renderWithData Template.annotationPreviewTooltip, tpl.data, div.get(0)

    tpl.data.annotationBoxElement.tooltipster 'hide'

    Meteor.setTimeout ->
      tpl.data.annotationBoxElement.tooltipster 'destroy'

      tpl.data.annotationBoxElement.tooltipster
        arrow: true
        content: div
        contentCloning: false
        interactive: true
        position: 'right'
        trigger: 'hover'
        autoClose: true
        theme: '.tooltipster-mirador'
    , 250

  'change select': (e, tpl) ->
    DeskWidgets.update tpl.data.widgetId,
      $set:
        annotationTypeFilter: ''
    Annotations.update @_id,
      $set:
        type: $(e.target).val()


Template.annotationPreviewTooltip.helpers
  reactiveAnnotation: ->
    Annotations.findOne @_id

Template.annotationPreviewTooltip.events
  'click button[data-action=edit]': (e, tpl) ->
    div = $('<div/>')
    data = _.extend tpl.data,
      editButtonElement: $(e.target)
    Blaze.renderWithData Template.annotationEditTooltip, data, div.get(0)

    buttonOffset = $(e.target).offset()

    # Special behavior to accomodate CKEDITOR
    tpl.editorRendered = false

    tpl.data.annotationBoxElement.tooltipster 'hide'

    Meteor.setTimeout ->
      tpl.data.annotationBoxElement.tooltipster 'destroy'

      tpl.data.annotationBoxElement.tooltipster
        arrow: true
        content: div
        contentCloning: false
        interactive: true
        position: 'right'
        trigger: 'click'
        autoClose: false
        #offsetY: -0.5 * buttonOffset.y
        #offsetX: -0.5 * buttonOffset.x
        theme: '.tooltipster-mirador'

        functionReady: (origin, tooltip) =>
          unless tpl.editorRendered
            tpl.editorRendered = true
            CKEDITOR.replace "editor-#{tpl.data._id}",
              customConfig: '/plugins/ckeditor/custom.js'

        functionAfter: (origin) =>
          if tpl.editorRendered
            tpl.editorRendered = false
            CKEDITOR.instances["editor-#{tpl.data._id}"].destroy()

      tpl.data.annotationBoxElement.tooltipster 'show'
    , 250

