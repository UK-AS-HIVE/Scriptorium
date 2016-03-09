@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.imageView =
  extendedData: ->
    annotationPanelOpen: false
    newAnnotation:
      isActive: false
      isDragging: false
      x1: 0
      y1: 0
      x2: 0
      y2: 0
  title: ->
    m = AvailableManifests.findOne(@manifestId).manifestPayload
    "Image View : " + m.label + ' / ' + m.sequences[0].canvases[@imageId].label
  height: 400
  width: 350
  contentClass: "mirador-widget-content-image-view"
  annotationsList:
    display: true
    width: 200

### Content - OSD ###
Template.mirador_imageView_content_osd.onDestroyed ->
  if @osd then @osd.destroy()

Template.mirador_imageView_content_osd.onRendered ->
  elemOsd = @.$('.mirador-osd')
    
  # Get information for OSD
  @data.image = AvailableManifests.findOne(@data.manifestId).manifestPayload.sequences[0].canvases[@data.imageId]
  osdToolbarId = "mirador-osd-#{@data._id}-toolbar"

  imgRes = @data.image.images[0].resource
  tileSources = ImageMetadata.findOne({retrievalUrl: imgRes.service['@id']+'/info.json'}).payload

  # Create osd at element
  @osd = miradorFunctions.openSeadragon
    id: elemOsd.attr('id')
    toolbar: osdToolbarId
    tileSources: tileSources

  @osd.addBlazeOverlay Template.osd_blaze_overlay, @data

  osd = @osd
  window.osd = @osd
  # When adding an annotation, disable the mouse from dragging the OSD canvas
  @autorun ->
    #osd.setMouseNavEnabled !Template.currentData().annotationPanelOpen
    osd.panHorizontal = osd.panVertical = !Template.currentData().newAnnotation.isActive

  @autorun ->
    # TODO: make sure pixel offsets are accurate
    if Template.currentData().annotationPanelOpen
      elemOsd.width(Template.currentData().width - 200)
    else
      elemOsd.width(Template.currentData().width-2)
    elemOsd.height(Template.currentData().height-100)
    if Template.instance().osd
      Template.instance().osd.viewport?.ensureVisible()

  @osd.addHandler 'open', =>
    if @data.zoom
      @osd.viewport.zoomTo @data.zoom, null, true
    if @data.center
      @osd.viewport.panTo @data.center, true

  @osd.addHandler 'animation-finish', (e) =>
    ActiveWidgets.update @data._id, { $set: { zoom: @osd.viewport.getZoom(), center: @osd.viewport.getCenter() } }


  ###
  @osd.addHandler 'open', ->
    # TODO: Make these work
    _this.addScale()
    _this.attachOsdEvents()
    _this.zoomLevel = _this.osd.viewport.getZoom()

    if typeof osdBounds != 'undefined'
      _this.osd.viewport.fitBounds(osdBounds, true)
  ###

Template.mirador_imageView_content_osd.helpers
  osdId: ->
    "mirador-osd-#{@_id}"

### Nav Toolbar ###

Template.mirador_imageView_navToolbar.helpers
  isOdd: (number) ->
    # Hack to make sure Blaze destroys and re-renders osd toolbar on image change.
    number % 2 != 0
  osdToolbarId: ->
    "mirador-osd-#{@_id}-toolbar"

Template.mirador_imageView_navToolbar.events
  'click .mirador-icon-previous': (e, tpl) ->
    if tpl.data.imageId > 0
      ActiveWidgets.update @_id, { $inc: { imageId: -1 } }

  'click .mirador-icon-next': (e, tpl) ->
    # TODO: Don't set imageId past the end of list
    ActiveWidgets.update @_id, { $inc: { imageId: 1 } }

  'click .mirador-icon-metadata-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'metadataView',
      manifestId: @manifestId

  'click .mirador-icon-load-editor': (e, tpl) ->
    m = AvailableManifests.findOne(@manifestId).manifestPayload
    label = m.label + ' / ' + m.sequences[0].canvases[@imageId].label
    Blaze.renderWithData Template.newDocModal, { name: label }, $('body').get(0)
    $('#newDocModal').modal('show')

  'click .mirador-icon-send-folio': (e, tpl) ->
    canvas = AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]
    imageId = canvas.images[0].resource.service['@id']

    now = new Date()

    newFolioId = folioItems.insert
      addedBy: Meteor.userId()
      lastUpdatedBy: Meteor.userId()
      imageURL: imageId
      dateAdded: now
      lastUpdated: now
      published: false
      manifest: Meteor.absoluteUrl "folio/manifest.json"
      canvas: null

    folioItems.update newFolioId,
      $set:
        canvas:
          "@id": Meteor.absoluteUrl "folio/canvas/#{newFolioId}"
          "@type": "sc:Canvas"
          label: canvas.label
          height: canvas.height || canvas.heigt
          width: canvas.width
          images: [
            "@id": Meteor.absoluteUrl "folio/image/#{newFolioId}"
            "@type": "oa:Annotation"
            motivation: "sc:painting"
            on: Meteor.absoluteUrl "folio/canvas/#{newFolioId}"
            resource:
              "@id": "#{imageId}/full/full/0/native.jpg"
              "@type": "dctypes:Image"
              format: "image/jpeg"
              height: canvas.images[0].resource.height
              width: canvas.images[0].resource.width
              service:
                "@id": imageId
                profile: "http://library.stanford.edu/iiif/image-api/1.1/conformance.html#level1"
          ]

    Session.set "editFolioItem", newFolioId
    Router.go('folioEdit')

  'click .mirador-icon-scroll-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'scrollView',
      manifestId: @manifestId

  'click .mirador-icon-thumbnails-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'thumbnailsView',
      manifestId: @manifestId

  'click .mirador-icon-annotations': (e, tpl) ->
    ActiveWidgets.update tpl.data._id,
      $set:
        annotationPanelOpen: !tpl.data.annotationPanelOpen

  'click .mirador-icon-annotorius': (e, tpl) ->
    # _this.openAnnotoriusWindow();
    #miradorFunctions.mirador_viewer_loadView 'openLayersAnnotoriusView', @manifestId, @imageId
    ActiveWidgets.update tpl.data._id,
      $set:
        'newAnnotation.isActive': true


### Status Bar ###
Template.mirador_imageView_statusbar.events
  'click .mirador-icon-lock': (e, tpl) ->
    if (_this.locked)
      _this.unlock()
    else
      _this.lock()

  'keypress .mirador-image-view-physical-dimensions, paste .mirador-image-view-physical-dimensions, keyup .mirador-image-view-physical-dimensions': (e, tpl) ->
    #_this.dimensionChange(e)
    console.log tpl
    valid = (/[0-9]|\./.test(String.fromCharCode(e.keyCode)) && !e.shiftKey)
    textAreaClass = e.currentTarget.className
    dimension = textAreaClass.charAt(textAreaClass.length-1)
    currentImg = AvailableManifests.findOne(tpl.data.manifestId).manifestPayload.sequences[0].canvases[tpl.data.imageId].images[0]
    res = currentImg.resource
    aspectRatio = parseInt(res.width)/parseInt(res.height)

    # check if the value of the number is an integer 0-9
    # if not, declare invalid
    if !valid
      e.preventDefault()

    # console.log(e.type+ " : " + e.key);

    # check if keystroke is "enter"
    # if so, exit or deselect the box
    if (e.keyCode || e.which) == 13
      e.target.blur()

    if dimension == 'x'
      width = tpl.$('.x').val()
      height = Math.floor(aspectRatio * width)
      if !width
        # console.log('empty');
        tpl.$('.y').val('')
      else
        tpl.$('.y').val(height)
    else
      height = tpl.$('.y').val()
      width = Math.floor(height/aspectRatio)
      if !height
        # console.log('empty');
        tpl.$('.x').val('')
      else
        tpl.$('.x').val(width)

    ActiveWidgets.update tpl.data._id,
      $set:
        scaleWidth: width
        scaleHeight: height
        scaleUnits: tpl.$('.units').val() || 'mm'

    ###
    TODO: when units have been specified, add scale overlay
    if (width)
      this.scale.dimensionsProvided = true
    else
      this.scale.dimensionsProvided = false
    this.scale.render()
    ###

  'input .units': ->
    #TODO
    _this.unitChange()

Template.mirador_imageView_statusbar.helpers
  width: ->
    '___'
  height: ->
    '___'

### Content ###
Template.mirador_imageView_content.helpers
  isOdd: (number) ->
    # Hack to make sure Blaze fully re-renders template on page change.
    _.isNull(number) or number % 2 != 0

Template.mirador_imageView_annotationPanel.helpers
  annotations: ->
    Annotations.find
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId

Template.mirador_imageView_annotationStats.helpers
  annotationCount: ->
    Annotations.find(
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId
    ).count()
  imageAnnotationCount: ->
    Annotations.find(
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId
      type: 'commenting'
    ).count()
  textAnnotationCount: ->
    Annotations.find(
      projectId: Session.get('current_project')
      manifestId: @manifestId
      canvasIndex: @imageId
      type:
        $not: 'commenting'
    ).count()

