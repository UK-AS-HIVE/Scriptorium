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
  infoJsonUrl = miradorFunctions.iiif_getUri("#{@data.image.images[0].resource.service['@id']}/info.json")
  osdToolbarId = "mirador-osd-#{@data.manifestId}-#{@data.imageId}-toolbar"
  infoJson = miradorFunctions.getJsonFromUrl infoJsonUrl, false

  imgRes = @data.image.images[0].resource
  tileSources = [{
    "@context": "http://library.stanford.edu/iiif/image-api/1.1/context.json"
    "@id": imgRes.service['@id'] #"http://loris.as.uky.edu/loris/folio%2FB024086201_MS423_0001r.jpg"
    height: parseInt imgRes.height #3880
    width: parseInt imgRes.width #2720
    profile: ["http://library.stanford.edu/iiif/image-api/compliance.html#level2"]
    protocol: "http://iiif.io/api/image/1.1"
    #tiles: [{
    #  scaleFactors: [1, 2, 4, 8, 16, 32]
    #  width: 1024
    #}]
  }]
  
  # Create osd at element
  @osd = miradorFunctions.openSeadragon
    id: elemOsd.attr('id')
    toolbar: osdToolbarId
    tileSources: tileSources

  @osd.addBlazeOverlay Template.osd_blaze_overlay, @data

  osd = @osd

  # When adding an annotation, disable the mouse from dragging the OSD canvas
  @autorun ->
    #osd.setMouseNavEnabled !Template.currentData().annotationPanelOpen
    osd.panHorizontal = osd.panVertical = !Template.currentData().newAnnotation.isActive

  @autorun ->
    elemOsd.width(Template.currentData().width-2).height(Template.currentData().height-100) # TODO: figure out pixel offsets
    if Template.instance().osd
      Template.instance().osd.viewport?.ensureVisible()

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
    "mirador-osd-#{@manifestId}-#{@imageId}-toolbar"

Template.mirador_imageView_navToolbar.events
 'click .mirador-icon-previous': (e, tpl) ->
   if tpl.data.imageId > 0
     ActiveWidgets.update @_id, { $inc: { imageId: -1 } }

  'click .mirador-icon-next': (e, tpl) ->
    # TODO: Don't set imageId past the end of list
    ActiveWidgets.update @_id, { $inc: { imageId: 1 } }

  'click .mirador-icon-metadata-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'metadataView', @manifestId

  'click .mirador-icon-load-editor': (e, tpl) ->
    # console.log("clicked editor button");
    # $.viewer.loadView("editorView", _this.manifestId);
    # Meteor.call("getNewEditorId", Meteor.user(), Session.get("current-project"), _this.openAt)
    Meteor.miradorFunctions.newDoc @openAt
    console.log @

  'click .mirador-icon-send-folio': (e, tpl) ->
    Meteor.miradorFunctions.createFolioEntry(_this.currentImg.imageUrl, _this.currentImg.height, _this.currentImg.width, _this.currentImg.title, Meteor.userId())

  'click .mirador-icon-scroll-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'scrollView', @manifestId

  'click .mirador-icon-thumbnails-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'thumbnailsView', @manifestId

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
    annos = Annotations.findOne
      manifest: @manifestId
      canvas: AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]['@id']
    annos?.annotations


Template.mirador_imageView_annotationStats.helpers
  annotationCount: ->
    annos = Annotations.findOne
      manifest: @manifestId
      canvas: AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]['@id']
    annos?.annotations?.length || 0
  imageAnnotationCount: ->
    annos = Annotations.findOne
      manifest: @manifestId
      canvas: AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]['@id']
    _.size _.filter annos?.annotations, (a) ->
      a.type == 'commenting'
  textAnnotationCount: ->
    annos = Annotations.findOne
      manifest: @manifestId
      canvas: AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId]['@id']
    _.size _.filter annos?.annotations, (a) ->
      a.type != 'commenting'

