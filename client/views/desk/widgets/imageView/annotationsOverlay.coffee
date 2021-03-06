@miradorFunctions = @miradorFunctions || {}
@miradorFunctions = _.extend @miradorFunctions, {
  openSeadragon: (options) ->
    return OpenSeadragon(
      _.extend {
        preserveViewport: true,
        visibilityRatio:  1,
        minZoomLevel:     0,
        showFullPageControl: false,
        defaultZoomLevel: 0,
        prefixUrl:        'images/openseadragon/',
        navImages: {
          zoomIn: {
            REST:   'zoom-in.png',
            GROUP:  'zoom-in.png',
            HOVER:  'zoom-in-hover.png',
            DOWN:   'zoom-in-hover.png'
          },
          zoomOut: {
            REST:   'zoom-out.png',
            GROUP:  'zoom-out.png',
            HOVER:  'zoom-out-hover.png',
            DOWN:   'zoom-out-hover.png'
          },
          home: {
            REST:   'fit.png',
            GROUP:  'fit.png',
            HOVER:  'fit-hover.png',
            DOWN:   'fit-hover.png'
          },
          fullpage: {
            REST:   'full-screen.png',
            GROUP:  'full-screen.png',
            HOVER:  'full-screen-hover.png',
            DOWN:   'full-screen-hover.png'
          },
          previous: {
            REST:   'previous.png',
            GROUP:  'previous.png',
            HOVER:  'previous-hover.png',
            DOWN:   'previous-hover.png'
          },
          next: {
            REST:   'next.png',
            GROUP:  'next.png',
            HOVER:  'next-hover.png',
            DOWN:   'next-hover.png'
          }
        }
      }, options)
}

OpenSeadragon.Viewer.prototype.addBlazeOverlay = (data) ->
  transform = new ReactiveVar
    translate:
      x: 0
      y: 0
    scale: 1

  imageWidth = AvailableManifests.findOne(data.manifestId).manifestPayload.sequences[0].canvases[data.imageId].images[0].resource.width

  viewer = @
  resize = ->
    p =  viewer.viewport.pixelFromPoint new OpenSeadragon.Point(0,0), true
    zoom = viewer.viewport.getZoom true
    scale = viewer.viewport._containerInnerSize.x * zoom
    transform.set
      translate: p
      scale: scale

  data = _.extend data,
    transform: transform
  svg = Blaze.renderWithData(Template.annotationsOverlay, data, @canvas)

  @addHandler 'open', (e) ->
    resize()

  @addHandler 'animation', (e) ->
    resize()

  @addHandler 'resize', (e) ->
    resize()

  @addHandler 'canvas-drag', (e) ->
    {x, y} = viewer.viewport.pointFromPixel e.position
    x = x*imageWidth
    y = y*imageWidth
    #console.log 'canvas-drag', x, y

    aw = DeskWidgets.findOne data._id
    if not aw.newAnnotation.isActive
      return

    if not aw.newAnnotation.isDragging
      console.log 'new canvas drag!'
      DeskWidgets.update data._id,
        $set:
          'newAnnotation.isDragging': true
          'newAnnotation.x1': x
          'newAnnotation.y1': y
          'newAnnotation.x2': x
          'newAnnotation.y2': y
    else
      DeskWidgets.update data._id,
        $set:
          'newAnnotation.x2': x
          'newAnnotation.y2': y
    
  @addHandler 'canvas-drag-end', (e) ->
    #TODO: prompt for annotation text, and add as annotation
    aw = DeskWidgets.findOne data._id
    if not aw.newAnnotation.isActive
      return

    newAnno = aw.newAnnotation
    console.log 'Create new annotation', newAnno

    DeskWidgets.update data._id,
      $set:
        newAnnotation:
          isActive: false
          isDragging: false
          x1: 0
          y1: 0
          x2: 0
          y2: 0

    annotationId = Annotations.insert
      projectId: Session.get('current_project')
      manifestId: data.manifestId
      canvasIndex: data.imageId
      text: 'Annotation'
      type: aw.annotationTypeFilter || 'transcription'
      x: Math.min(aw.newAnnotation.x1, aw.newAnnotation.x2)
      y: Math.min(aw.newAnnotation.y1, aw.newAnnotation.y2)
      w: Math.abs(aw.newAnnotation.x2 - aw.newAnnotation.x1)
      h: Math.abs(aw.newAnnotation.y2 - aw.newAnnotation.y1)

    # TODO: do we want annotation text to live in file cabinet?
    ###
    fileCabinetId = FileCabinet.insert
      title: "Annotation on #{data.manifestId} image #{data.imageId}.anno"
      description: "Annotation on #{data.manifestId} image #{data.imageId}"
      fileType: "annotation"
      content: ''
      open: true
      date: new Date()
      project: Session.get('current_project')
      user: Meteor.userId()

    miradorFunctions.mirador_viewer_loadView 'editorView',
      manifestId: data.manifestId
      fileCabinetId: fileCabinetId
    ###

Template.annotationsOverlay.helpers
  transform: ->
    @transform.get()
  annotationPanelOpen: ->
    DeskWidgets.findOne(@_id)?.annotationPanelOpen
  annotations: ->

    canvas = AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]
    imageWidth = parseInt(canvas.images[0].resource.width)
    transform = @transform.get()
    selector =
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId
    w = DeskWidgets.findOne(@_id)
    if w.annotationTypeFilter isnt ''
      selector.type = w.annotationTypeFilter
    return Annotations.find(selector).map (a) ->
      _.extend a,
        transform: transform
        x: a.x / imageWidth
        y: a.y / imageWidth
        w: a.w / imageWidth
        h: a.h / imageWidth
        widgetId: w._id
  newAnnotation: ->
    aw = DeskWidgets.findOne(@_id)
    canvas = AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]
    imageWidth = parseInt(canvas.images[0].resource.width)
    transform = @transform.get()
    if aw.newAnnotation.isActive
      transform: transform
      isDragging: aw.newAnnotation.isDragging
      x: Math.min(aw.newAnnotation.x1, aw.newAnnotation.x2) / imageWidth
      y: Math.min(aw.newAnnotation.y1, aw.newAnnotation.y2) / imageWidth
      w: Math.abs(aw.newAnnotation.x2 - aw.newAnnotation.x1) / imageWidth
      h: Math.abs(aw.newAnnotation.y2 - aw.newAnnotation.y1) / imageWidth

Template.annotationBoundingBox.onRendered ->
  div = $('<div/>')
  data = _.extend @data,
    annotationBoxElement: @.$('.annotation-box')
  Blaze.renderWithData Template.annotationPreviewTooltip, data, div.get(0)

  @.$('.annotation-box').tooltipster
    arrow: true
    content: div
    contentCloning: false
    interactive: true
    position: 'right'
    trigger: 'hover'
    autoClose: true
    theme: '.tooltipster-mirador'

Template.annotationBoundingBox.helpers
  x: -> (@x * @transform.scale) + @transform.translate.x
  y: -> (@y * @transform.scale) + @transform.translate.y
  w: -> @w * @transform.scale
  h: -> @h * @transform.scale
  borderSize: ->
    if Session.get('hoveredAnnotationId') is @_id then 3 else 1

Template.newAnnotationBoundingBox.helpers
  x: -> (@x * @transform.scale) + @transform.translate.x
  y: -> (@y * @transform.scale) + @transform.translate.y
  w: -> @w * @transform.scale
  h: -> @h * @transform.scale
  borderSize: -> 1

