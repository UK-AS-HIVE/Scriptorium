@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.imageView =
  extendedData: ->
    annotationPanelOpen: false
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
  
  # Create osd at element
  Template.instance().osd = miradorFunctions.openSeadragon
    id: elemOsd.attr('id')
    toolbar: osdToolbarId
    tileSources: miradorFunctions.iiif_prepJsonForOsd(infoJson)
  
  $("#mirador-osd-#{@data.manifestId}-#{@data.imageId}-toolbar button:last-child").hide()

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
    "mirador-osd-#{@manifestId}-#{@imageId}"

Template.mirador_imageView_imageChoices.helpers
  choicesInfo: ->
    canvas = AvailableManifests.findOne(@manifestId)?.manifestPayload.sequences[0].canvases[@imageId]
    choiceList = []
    _.each canvas.images, (image) ->
      if image.resource.hasOwnProperty('@type') and image.resource['@type'] is 'oa:Choice'
        console.log 'image has choices'
        # tentatively not implementing this. can consider it later.
      else
        choiceList.push
          id: @imageId
          manifestId: @manifestId
          imageUrl: image.resource.service['@id'].replace(/\/$/, '')
          choices: []
          label: image.resource.label || 'Default'

    if @showNoImageChoiceOption
      choiceList.push
        imageUrl: null
        choices: []
        label: 'No Image'

    return choiceList

Template.mirador_imageView_imageChoices.events
  'click .mirador-image-view-choice': (e, tpl) ->
    if tpl.$(e.target).data('choice') is 'No Image'
      #TODO: Make this work
      console.log 'destroy osd'
    else
      ActiveWidgets.update tpl.data._id, { $set: { imageId: tpl.$(e.target).data('image-id') } }


### Nav Toolbar ###

Template.mirador_imageView_navToolbar.onRendered ->
  imageChoices = $('<div/>')
  Blaze.renderWithData Template.mirador_imageView_imageChoices, _.extend(ActiveWidgets.findOne(@data._id), { showNoImageChoiceOption: true }), imageChoices.get(0)
  @.$('.mirador-icon-choices').tooltipster
    arrow: true
    content: imageChoices
    contentCloning: false
    interactive: true
    position: 'bottom'
    theme: '.tooltipster-mirador'

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
    $.viewer.loadView('openLayersAnnotoriusView', _this.manifestId, _this.currentImg.id)


### Status Bar ###
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

### Content ###
Template.mirador_imageView_content.helpers
  isOdd: (number) ->
    # Hack to make sure Blaze fully re-renders template on page change.
    _.isNull(number) or number % 2 != 0

