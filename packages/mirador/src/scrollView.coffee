@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.scrollView =
  title: ->
    'Scroll View : ' + AvailableManifests.findOne(@manifestId).manifestPayload.label
  height: 400
  width: 600
  imageLabelHeight: 25
  toolbarHeight: 25

Template.mirador_scrollView_content.helpers
  scrollWidth: ->
    # TODO: should update based on contents and widget height
    # look at setFrameAndItemsDimensions for reference
    # implementation
    '10000px'
  scrollHeight: ->
    @height - 70
  thumbHeight: ->
    Template.parentData().size.get().height - 150
  images: ->
    console.log 'mirador_scrollView_listImages.images', @
    height = @height - 150
    _.map AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases, (c) ->
      title: c.label
      uriWithHeight: miradorFunctions.iiif_getUriWithHeight c.images[0].resource.service['@id'], height

Template.mirador_scrollView_navToolbar.events
  'click .mirador-icon-metadata-view': ->
    miradorFunctions.mirador_viewer_loadView 'metadataView', @manifestId
  'click .mirador-icon-thumbnails-view': ->
    miradorFunctions.mirador_viewer_loadView 'thumbnailsView', @manifestId

