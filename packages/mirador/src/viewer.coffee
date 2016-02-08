Template.mirador_viewer.helpers
  widgets: ->
    ActiveWidgets.find()

Template.mirador_viewer.onRendered ->
  $(window).on 'resizestart', (event) ->
    if (event.target == window)
      #_this.saveCurrentWindowSize()
      # TODO: port from viewer.js
      return

  $(window).on 'resizestop', (event) ->
    if (event.target == window)
      #_this.resizeViewer()
      # TODO: port from viewer.js
      return

  #TODO
  #this.alignViewerElements();
  #this.addParsePluginForAnnotorius();
  return

Meteor.methods
  mirador_viewer_addParsePluginForAnnotorius: ->
    # TODO
    anno.addPlugin 'Parse',
      'app_id': $.DEFAULT_SETTINGS.openLayersAnnotoriusView.appId,
      'js_key': $.DEFAULT_SETTINGS.openLayersAnnotoriusView.jsKey

  mirador_viewer_alignViewerElements: ->
    this.canvas.height(this.element.height() - this.mainMenu.element.outerHeight(true))

    if (this.showStatusBar)
      this.canvas.height(this.canvas.height() - this.statusBar.element.outerHeight(true))

  mirador_viewer_renderWidgetsForCollection: (collection) ->
    _this = this

    jQuery.each collection.widgets, (index, config) ->
      if (!jQuery.isEmptyObject(config) && $.isValidView(config.type))
        config.manifestId = $.getManifestIdByUri(collection.manifestUri)
        _this.addWidget(config)

    if typeof this.initialLayout != 'undefined'
      console.log("undefined" + " " + this.initialLayout)
      $.viewer.layout.applyLayout(this.initialLayout)
      this.currentLayout = this.initialLayout

  mirador_viewer_addWidget: (config) ->
    ActiveWidgets.insert config
    return

    jQuery.extend true, config,
      appendTo: this.canvas,
      id: 'mirador-widget-' + ($.genUUID()),
      position: {
        my: this.getWidgetPosition()
      }

    this.widgets.push(new $.Widget(config))

  mirador_viewer_removeWidget: (id) ->
    jQuery.each $.viewer.widgets, (index, widget) ->
      if (widget && widget.id == id)
        if (widget.type == 'imageView')
          $.viewer.lockController.removeLockedView(widget.id)

        $.viewer.widgets.splice(index, 1)

  mirador_viewer_findWidget: (type, manifestId, imageId) ->
    # filter this.widgets for matching widgets to enable basic
    # inter-widget-communication
    matches = []

    jQuery.each $.viewer.widgets, (index, widget) ->
      if (widget.type == type && widget.manifestId == manifestId)
        if (!imageId || (this.imageId == imageId))
          matches.push(widget)

    return matches


  mirador_viewer_deleteOpenOpenLayersAnnotoriusViews: ->
    jQuery.each $.viewer.widgets, (index, widget) ->
      if (widget.type == "openLayersAnnotoriusView" )
        widget.close()

  mirador_viewer_loadView: (type, manifestId, image, openAt) ->
    console.log 'loadView', arguments
    Meteor.call 'mirador_viewer_addWidget',
      height:     400
      manifestId: manifestId
      openAt:     openAt
      image:      image
      type:       type
      width:      350

  mirador_viewer_getWidgetPosition: ->
    offsetIncrement = 25
    positionX = this.lastWidgetPosition.x + '+' + this.lastWidgetPosition.offset
    positionY = this.lastWidgetPosition.y + '+' + this.lastWidgetPosition.offset

    this.lastWidgetPosition.offset += offsetIncrement

    return positionX + ' ' + positionY

  mirador_viewer_updateLoadWindowContent: ->
    tplData =
      cssCls:  this.collectionsListingCls
      collections: []
    groupedList = this.arrangeCollectionsFromManifests()
    locations = []

    # sort by location name
    jQuery.each groupedList, (location, list) ->
      locations.push(location)

    jQuery.each locations.sort(), (index, location) ->
      tplData.collections.push
        location: location
        list: groupedList[location]

    $.loadWindowContent = $.Templates.mainMenu.loadWindowContent(tplData)

    jQuery(this.mainMenuLoadWindowCls).tooltipster('update', $.loadWindowContent)


  mirador_viewer_arrangeCollectionsFromManifests: ->
    groupedList = {}

    if !jQuery.isEmptyObject($.manifests)
      jQuery.each $.manifests, (manifestId, manifest) ->
        location = manifest.location

        if typeof groupedList[location] == 'undefined'
          groupedList[location] = []

        groupedList[location].push
          manifestId:       manifestId
          collectionTitle:  $.trimStringBy($.getCollectionTitle(manifest.metadata), 60)
          imageData:        $.getImageTitlesAndIds(manifest.sequences[0].imagesList)

    # sort by collection title
    jQuery.each groupedList, (location, list) ->
      groupedList[location] = groupedList[location].sort (a, b) ->
        return a.collectionTitle.localeCompare(b.collectionTitle)

    return groupedList

  mirador_viewer_addStatusBarMessage: (position, content, delay, hide) ->
    elTextFrame = this.statusBar.element.find('.mirador-status-bar-msg-' + position)

    delay = isNaN(delay) ? 0 : delay

    if hide && typeof hide != 'boolean'
      hide = true

    elTextFrame.text(content)

    if (hide)
      setTimeout (-> elTextFrame.fadeOut(); ), delay

