Template.mirador_imageView_content.onRendered ->
  infoJsonUrl = miradorFunctions.iiif_getUri("#{@data.image.imageUrl}/info.json")
  osdToolbarId = "mirador-osd-#{@data.image.id}-toolbar"
  infoJson = miradorFunctions.getJsonFromUrl infoJsonUrl, false
  elemOsd = @$('.mirador-osd')
  @osd = miradorFunctions.openSeadragon  {
    id: elemOsd.attr('id')
    toolbar: osdToolbarId
    tileSources: miradorFunctions.iiif_prepJsonForOsd(infoJson)
  }

  @osd.addHandler 'open', ->
    # TODO: Make these work
    _this.addScale()
    _this.attachOsdEvents()
    _this.zoomLevel = _this.osd.viewport.getZoom()

    if typeof osdBounds != 'undefined'
      _this.osd.viewport.fitBounds(osdBounds, true)


Template.mirador_imageView_navToolbar.helpers
  osdToolbarId: ->
    "mirador-osd-#{@image?.id}-toolbar"

Template.mirador_imageView_navToolbar.onCreated ->
  console.log 'created imageView widget navToolbar!'

Template.mirador_imageView_navToolbar.events
 'click .mirador-icon-previous': (e, tpl) ->
    _this.prev()

  'click .mirador-icon-next': (e, tpl) ->
    _this.next()

  'click .mirador-icon-metadata-view': (e, tpl) ->
    $.viewer.loadView("metadataView", _this.manifestId)

  'click .mirador-icon-load-editor': (e, tpl) ->
    # console.log("clicked editor button");
    # $.viewer.loadView("editorView", _this.manifestId);
    # Meteor.call("getNewEditorId", Meteor.user(), Session.get("current-project"), _this.openAt)
    Meteor.miradorFunctions.newDoc(_this.openAt)
    console.log(_this)

  'click .mirador-icon-send-folio': (e, tpl) ->
    Meteor.miradorFunctions.createFolioEntry(_this.currentImg.imageUrl, _this.currentImg.height, _this.currentImg.width, _this.currentImg.title, Meteor.userId())

  'click .mirador-icon-scroll-view': (e, tpl) ->
    $.viewer.loadView("scrollView", _this.manifestId)

  'click .mirador-icon-thumbnails-view': (e, tpl) ->
    $.viewer.loadView("thumbnailsView", _this.manifestId)

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
    "mirador-osd-#{@image?.id}"
