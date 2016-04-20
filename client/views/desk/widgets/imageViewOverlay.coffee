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
  transform = new ReactiveVar
    translate:
      x: 0
      y: 0
    scale: 1

  imageWidth = AvailableManifests.findOne(data.manifestId).manifestPayload.sequences[0].canvases[data.imageId].images[0].resource.width

  resize = ->
    p =  viewer.viewport.pixelFromPoint new OpenSeadragon.Point(0,0), true
    zoom = viewer.viewport.getZoom true
    scale = viewer.viewport._containerInnerSize.x * zoom
    transform.set
      translate: p
      scale: scale

  data = _.extend data,
    transform: transform
  svg = Blaze.renderWithData(Template.osd_blaze_overlay, data, @canvas)

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

Template.osd_blaze_overlay.helpers
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

Template.osd_blaze_overlay_annotation.onRendered ->
  div = $('<div/>')
  data = _.extend @data,
    annotationBoxElement: @.$('.annotation-box')
  Blaze.renderWithData Template.osd_blaze_overlay_annotation_tooltip_preview, data, div.get(0)

  @.$('.annotation-box').tooltipster
    arrow: true
    content: div
    contentCloning: false
    interactive: true
    position: 'right'
    trigger: 'hover'
    autoClose: true
    theme: '.tooltipster-mirador'

Template.osd_blaze_overlay_new_annotation.helpers
  x: -> (@x * @transform.scale) + @transform.translate.x
  y: -> (@y * @transform.scale) + @transform.translate.y
  w: -> @w * @transform.scale
  h: -> @h * @transform.scale
  borderSize: -> 1

Template.osd_blaze_overlay_annotation.helpers
  x: -> (@x * @transform.scale) + @transform.translate.x
  y: -> (@y * @transform.scale) + @transform.translate.y
  w: -> @w * @transform.scale
  h: -> @h * @transform.scale
  borderSize: ->
    if Session.get('hoveredAnnotationId') is @_id then 3 else 1

Template.osd_blaze_overlay_annotation_tooltip.helpers
  reactiveAnnotation: ->
    Annotations.findOne @_id
  selectedIf: (type) ->
    if @type == type then 'selected'

Template.osd_blaze_overlay_annotation_tooltip.events
  'click button[data-action=save-annotation]': (e, tpl) ->
    Annotations.update tpl.data._id,
      $set:
        text: CKEDITOR.instances["editor-#{tpl.data._id}"].getData()
  'click button[data-action=delete-annotation]': (e, tpl) ->
    Annotations.remove @_id
  'click .close-anno-tooltip': (e, tpl) ->
    div = $('<div/>')
    Blaze.renderWithData Template.osd_blaze_overlay_annotation_tooltip_preview, tpl.data, div.get(0)

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

  'change select': (e, tpl) ->
    DeskWidgets.update tpl.data.widgetId,
      $set:
        annotationTypeFilter: ''
    Annotations.update @_id,
      $set:
        type: $(e.target).val()

Template.osd_blaze_overlay_annotation_tooltip_preview.onRendered ->
    # Special behavior to accomodate CKEDITOR
  editorRendered = false

Template.osd_blaze_overlay_annotation_tooltip_preview.helpers
  reactiveAnnotation: ->
    Annotations.findOne @_id

Template.osd_blaze_overlay_annotation_tooltip_preview.events
  'click button[data-action=edit]': (e, tpl) ->
    div = $('<div/>')
    data = _.extend tpl.data,
      editButtonElement: $(e.target)
    Blaze.renderWithData Template.osd_blaze_overlay_annotation_tooltip, data, div.get(0)

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
    , 20

