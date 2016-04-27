Template.mirador_imageView_annotationPanel.helpers
  annotations: ->
    selector =
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId
    if @annotationTypeFilter isnt ''
      selector.type = @annotationTypeFilter
    Annotations.find selector

Template.mirador_imageView_annotationStats.events
  'click .close-anno-panel': (e, tpl) ->
    DeskWidgets.update tpl.data._id,
      $set:
        'annotationPanelOpen': false
  'click .mirador-icon-annotorius': (e, tpl) ->
    DeskWidgets.update tpl.data._id,
      $set:
        'newAnnotation.isActive': true
  'change select.annotationTypeSelector': (e, tpl) ->
    DeskWidgets.update tpl.data._id,
      $set:
        'annotationTypeFilter': $(e.target).val()

Template.mirador_imageView_annotationStats.helpers
  selectedAnnotationType: (type) ->
    if @annotationTypeFilter == type then 'selected'
  annotationCount: ->
    Annotations.find(
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId
    ).count()
  commentaryAnnotationCount: ->
    Annotations.find(
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId
      type: 'commentary'
    ).count()
  transcriptionAnnotationCount: ->
    Annotations.find(
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId
      type: 'transcription'
    ).count()

Template.mirador_imageView_annotationListing.events
  'click .annotationListing': (e, tpl) ->
    osd = Template.parentData().osd.get()
    widgetData = Template.parentData()

    # Zoom OpenSeadragon to annotation
    canvas = AvailableManifests.findOne(widgetData.manifestId).manifestPayload.sequences[0].canvases[widgetData.imageId]
    imageWidth = parseInt(canvas.images[0].resource.width)

    osd.viewport.zoomTo (0.5*imageWidth / Math.max(@w, @h))
    osd.viewport.panTo
      x: (@x + @w / 2) / imageWidth
      y: (@y + @h / 2) / imageWidth

  'mouseenter .annotationListing': (e, tpl) ->
    Session.set 'hoveredAnnotationId', tpl.data._id
  'mouseleave .annotationListing': (e, tpl) ->
    Session.set 'hoveredAnnotationId', null

Template.mirador_imageView_annotationListing.helpers
  sanitized: (html) ->
    sanitizeHtml html

