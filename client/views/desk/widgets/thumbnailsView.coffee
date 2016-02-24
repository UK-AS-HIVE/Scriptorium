@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.thumbnailsView =
  label: 'Thumbnails View'
  title: ->
    'Thumbnails View : ' + AvailableManifests.findOne(@manifestId).manifestPayload.label
  height: 400
  width: 600
  contentClass: "mirador-widget-content-thumbnail-view"
  thumbsMaxHeight: 150
  thumbsMinHeight: 50
  thumbsDefaultZoom: 0.5

Template.mirador_thumbnailsView_listImages.helpers
  thumbs: ->
    console.log 'getting thumbs list for ', @
    _.map AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases, (c, index) ->
      imageUrl = c.images[0].resource.service['@id']
      thumbUrl: miradorFunctions.iiif_getUriWithHeight imageUrl, miradorWidgetProperties.thumbnailsView.thumbsMaxHeight
      title:    c.label
      id:       index
  thumbsDefaultHeight: ->
    p = miradorWidgetProperties.thumbnailsView
    p.thumbsMinHeight + (p.thumbsMaxHeight - p.thumbsMinHeight) * p.thumbsDefaultZoom

Template.mirador_thumbnailsView_listImages.events
  'click .listing-thumbs li a': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'imageView',
      manifestId: Template.currentData().manifestId
      imageId: @id

  # TODO: the slider seems to have been removed at some point.
  # We can probably remove this.
  'slide': (e, ui, tpl) ->
    # Not sure how jquery UI handles these events - might have to put them in onRendered
    $(e.target).attr('height', ui.value)

Template.mirador_thumbnailsView_navToolbar.events
  'click .mirador-icon-metadata-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'metadataView',
      manifestId: @manifestId

  'click .mirador-icon-scroll-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'scrollView',
      manifestId: @manifestId

