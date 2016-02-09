@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.imageView =
  title: ->
    titles = []
    titles.push "Image View : " + AvailableManifests.findOne(@manifestId).manifestPayload.label
    if @imageId
      titles.push AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases[@imageId].label
    titles.join(' / ')
  height: 400
  width: 350
  annotationsList:
    display: true
    width: 200

Template.mirador_imageView_content.onRendered ->
  tpl = @
  elemOsd = @.$('.mirador-osd')
  @autorun ->
    tpl.data.image = AvailableManifests.findOne(tpl.data.manifestId).manifestPayload.sequences[0].canvases[tpl.data.imageId]
    infoJsonUrl = miradorFunctions.iiif_getUri("#{tpl.data.image.images[0].resource.service['@id']}/info.json")
    osdToolbarId = "mirador-osd-#{tpl.data.manifestId}-#{tpl.data.imageId}-toolbar"
    infoJson = miradorFunctions.getJsonFromUrl infoJsonUrl, false
    tpl.osd = miradorFunctions.openSeadragon
      id: elemOsd.attr('id')
      toolbar: osdToolbarId
      tileSources: miradorFunctions.iiif_prepJsonForOsd(infoJson)
    
  @autorun ->
    size = Template.currentData().size.get()
    elemOsd.width(size.width-2).height(size.height-100) # TODO: figure out pixel offsets
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


Template.mirador_imageView_navToolbar.helpers
  osdToolbarId: ->
    "mirador-osd-#{@manifestId}-#{@imageId}-toolbar"

Template.mirador_imageView_navToolbar.events
 'click .mirador-icon-previous': (e, tpl) ->
   ActiveWidgets.update @_id, { $inc: { imageId: -1 } }

  'click .mirador-icon-next': (e, tpl) ->
   ActiveWidgets.update @_id, { $inc: { imageId: 1 } }

  'click .mirador-icon-metadata-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'metadataView', @manifestId

  'click .mirador-icon-load-editor': (e, tpl) ->
    # console.log("clicked editor button");
    # $.viewer.loadView("editorView", _this.manifestId);
    # Meteor.call("getNewEditorId", Meteor.user(), Session.get("current-project"), _this.openAt)
    Meteor.miradorFunctions.newDoc(_this.openAt)
    console.log(_this)

  'click .mirador-icon-send-folio': (e, tpl) ->
    Meteor.miradorFunctions.createFolioEntry(_this.currentImg.imageUrl, _this.currentImg.height, _this.currentImg.width, _this.currentImg.title, Meteor.userId())

  'click .mirador-icon-scroll-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'scrollView', @manifestId

  'click .mirador-icon-thumbnails-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'thumbnailsView', @manifestId

  'click .mirador-icon-annotations': (e, tpl) ->
    _this.annotationsLayer.setVisible()

  'click .mirador-icon-annotorius': (e, tpl) ->
    # _this.openAnnotoriusWindow();
    $.viewer.loadView('openLayersAnnotoriusView', _this.manifestId, _this.currentImg.id)

Template.mirador_imageView_statusbar.events
  'click .mirador-icon-lock': (e, tpl) ->
    if (_this.locked)
      _this.unlock()
    else
      _this.lock()

  'keypress .mirador-image-view-physical-dimensions, paste .mirador-image-view-physical-dimensions, keyup .mirador-image-view-physical-dimensions': (e, tpl) ->
    _this.dimensionChange(e)

  'input .units': ->
    _this.unitChange()

Template.mirador_imageView_statusbar.helpers
  width: ->
    '___'
  height: ->
    '___'

Template.mirador_imageView_content.helpers
  osdId: ->
    "mirador-osd-#{@manifestId}-#{@imageId}"
