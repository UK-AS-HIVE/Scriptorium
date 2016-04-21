@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.imageView =
  extendedData: ->
    annotationPanelOpen: false
    annotationTypeFilter: ''
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

  # When adding an annotation, disable the mouse from dragging the OSD canvas
  @autorun ->
    #osd.setMouseNavEnabled !Template.currentData().annotationPanelOpen
    osd.panHorizontal = osd.panVertical = !Template.currentData().newAnnotation.isActive
  
  @autorun =>
    # Limit reactivity scope here to make sure we're not calling ensureVisible everytime OSD zoom changes.
    data = DeskWidgets.findOne(@data._id, { fields: { 'height': 1, 'width': 1, 'annotationPanelOpen': 1 } } )

    # TODO: make sure pixel offsets are accurate
    if data.annotationPanelOpen
      elemOsd.width(data.width - 200)
    else
      elemOsd.width(data.width-2)
    elemOsd.height(data.height-100)
    if Template.instance().osd
      Template.instance().osd.viewport?.ensureVisible()

  @autorun =>
    zoomLocked = DeskWidgets.findOne(@data._id, { fields: { 'zoomLocked': 1 } }).zoomLocked
    if zoomLocked
      @osd.zoomPerScroll = 1
      @osd.zoomPerClick = 1
      @osd.panHorizontal = @osd.panVertical = false
    else
      @osd.zoomPerScroll = 1.15
      @osd.zoomPerClick = 2
      @osd.panHorizontal = @osd.panVertical = true


  @osd.addHandler 'open', =>
    if @data.zoom
      @osd.viewport.zoomTo @data.zoom, null, true
    if @data.center
      @osd.viewport.panTo @data.center, true

  @osd.addHandler 'animation-finish', (e) =>
    DeskWidgets.update @data._id, { $set: { zoom: @osd.viewport.getZoom(), center: @osd.viewport.getCenter() } }

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
      DeskWidgets.update @_id, { $inc: { imageId: -1 } }

  'click .mirador-icon-next': (e, tpl) ->
    # TODO: Don't set imageId past the end of list
    DeskWidgets.update @_id, { $inc: { imageId: 1 } }

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
      projectId: Session.get('current_project')
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

  'click .mirador-icon-scroll-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'scrollView',
      manifestId: @manifestId

  'click .mirador-icon-thumbnails-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'thumbnailsView',
      manifestId: @manifestId

  'click .mirador-icon-annotations': (e, tpl) ->
    DeskWidgets.update tpl.data._id,
      $set:
        annotationPanelOpen: !tpl.data.annotationPanelOpen

### Status Bar ###
Template.mirador_imageView_statusbar.events
  'click a[data-action=toggleLock]': (e, tpl) ->
    DeskWidgets.update @_id, { $set: { zoomLocked: !tpl.data.zoomLocked } }

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


