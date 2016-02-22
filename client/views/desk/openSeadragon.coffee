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

OpenSeadragon.Viewer.prototype.addBlazeOverlay = (template, data) ->
  viewer = @
  transform = new ReactiveVar()

  imageWidth = AvailableManifests.findOne(data.manifestId).manifestPayload.sequences[0].canvases[data.imageId].images[0].resource.width

  resize = ->
    p =  viewer.viewport.pixelFromPoint new OpenSeadragon.Point(0,0), true
    zoom = viewer.viewport.getZoom true
    scale = viewer.viewport._containerInnerSize.x * zoom
    transform.set "translate(#{p.x},#{p.y}) scale(#{scale})"

  data = _.extend data,
    transform: transform
  svg = Blaze.renderWithData(Template.osd_blaze_overlay, data, @canvas)

  @addHandler 'open', (e) ->
    resize()

  @addHandler 'animation', (e) ->
    resize()

  @addHandler 'canvas-drag', (e) ->
    {x, y} = viewer.viewport.pointFromPixel e.position
    x = x*imageWidth
    y = y*imageWidth
    #console.log 'canvas-drag', x, y

    aw = ActiveWidgets.findOne data._id
    if not aw.newAnnotation.isActive
      return

    if not aw.newAnnotation.isDragging
      console.log 'new canvas drag!'
      ActiveWidgets.update data._id,
        $set:
          'newAnnotation.isDragging': true
          'newAnnotation.x1': x
          'newAnnotation.y1': y
          'newAnnotation.x2': x
          'newAnnotation.y2': y
    else
      ActiveWidgets.update data._id,
        $set:
          'newAnnotation.x2': x
          'newAnnotation.y2': y
    
   @addHandler 'canvas-drag-end', (e) ->
     #TODO: prompt for annotation text, and add as annotation
     newAnno = ActiveWidgets.findOne(data._id).newAnnotation
     console.log 'Create new annotation', newAnno

     ActiveWidgets.update data._id,
       $set:
         newAnnotation:
           isActive: false
           isDragging: false
           x1: 0
           y1: 0
           x2: 0
           y2: 0

Template.osd_blaze_overlay.helpers
  transform: ->
    @transform.get()
  annotationPanelOpen: ->
    ActiveWidgets.findOne(@_id)?.annotationPanelOpen
  annotations: ->
    canvas = AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]
    imageWidth = parseInt(canvas.images[0].resource.width)
    _.map Annotations.findOne({
      manifest: @manifestId
      canvas: canvas['@id']
    }).annotations, (a) ->
      x: a.x / imageWidth
      y: a.y / imageWidth
      w: a.w / imageWidth
      h: a.h / imageWidth
      text: a.text
  newAnnotation: ->
    aw = ActiveWidgets.findOne(@_id)
    canvas = AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]
    imageWidth = parseInt(canvas.images[0].resource.width)
    if aw.newAnnotation.isActive
      x: Math.min(aw.newAnnotation.x1, aw.newAnnotation.x2) / imageWidth
      y: Math.min(aw.newAnnotation.y1, aw.newAnnotation.y2) / imageWidth
      w: Math.abs(aw.newAnnotation.x2 - aw.newAnnotation.x1) / imageWidth
      h: Math.abs(aw.newAnnotation.y2 - aw.newAnnotation.y1) / imageWidth

