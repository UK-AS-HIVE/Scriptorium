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

