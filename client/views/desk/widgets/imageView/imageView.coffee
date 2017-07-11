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

  @data.image = AvailableManifests.findOne(@data.manifestId).manifestPayload.sequences[0].canvases[@data.imageId]
  @osd = null

  Meteor.call 'getMetadataPayloadFromUrl', @data.image.images[0].resource.service['@id']+'/info.json', (err, res) =>
    # Get image metadata, and instantiate OpenSeadragon once we've done so.
    
    osdToolbarId = "mirador-osd-#{@data._id}-toolbar"

    # Create osd at element
    osd = @osd = miradorFunctions.openSeadragon
      id: elemOsd.attr('id')
      toolbar: osdToolbarId
      tileSources: res

    @osd.addBlazeOverlay @data

    # Make OSD accessible annotationsPanel
    @data.osd.set @osd

    @osd.addHandler 'open', =>
      if @data.zoom
        @osd.viewport.zoomTo @data.zoom, null, true
      if @data.center
        @osd.viewport.panTo @data.center, true

    @osd.addHandler 'animation-finish', (e) =>
      DeskWidgets.update @data._id, { $set: { zoom: @osd.viewport.getZoom(), center: @osd.viewport.getCenter() } }

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
    w = DeskWidgets.findOne @data._id,
      fields:
        'newAnnotation.isActive': 1
        zoomLocked: 1

    # If lock is activated, disable zoom and pan
    if w.zoomLocked
      @osd?.zoomPerScroll = 1
      @osd?.zoomPerClick = 1
    else
      @osd?.zoomPerScroll = 1.15
      @osd?.zoomPerClick = 2

    # Disable mouse pan either when lock activated or when adding an annotation
    @osd?.panHorizontal = @osd?.panVertical = !w.zoomLocked and !w.newAnnotation.isActive

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
    Meteor.call 'sendToExhibit', Session.get('current_project'), @manifestId, @imageId, (err, res) ->
      Session.set "editFolioItem", res
      Router.go '/folio/edit'

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
Template.mirador_imageView_content.onCreated ->
  @osd = new ReactiveVar null

Template.mirador_imageView_content.helpers
  isOdd: (number) ->
    # Hack to make sure Blaze fully re-renders template on page change.
    _.isNull(number) or number % 2 != 0
  dataWithOsdReactiveVar: ->
    _.extend Template.currentData(),
      osd: Template.instance().osd


