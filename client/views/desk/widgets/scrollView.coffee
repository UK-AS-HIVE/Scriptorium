@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.scrollView =
  title: ->
    'Scroll View : ' + AvailableManifests.findOne(@manifestId).manifestPayload.label
  height: 400
  width: 600
  contentClass: "mirador-widget-content-scroll-view"
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
    Template.parentData().height - 150
  images: ->
    console.log 'mirador_scrollView_listImages.images', @
    manifest = AvailableManifests.findOne(@manifestId).manifestPayload
    height = @height - 150
    _.map manifest.sequences[0].canvases, (c, idx) ->
      imageInfo = ImageMetadata.findOne({retrievalUrl: c.images[0].resource.service['@id']+'/info.json'}).payload
      index: idx
      title: c.label
      uriWithHeight: miradorFunctions.iiif_getUriWithHeight imageInfo, height

Template.mirador_scrollView_navToolbar.events
  'click .mirador-icon-metadata-view': ->
    miradorFunctions.mirador_viewer_loadView 'metadataView',
      manifestId: @manifestId
  'click .mirador-icon-thumbnails-view': ->
    miradorFunctions.mirador_viewer_loadView 'thumbnailsView',
      manifestId: @manifestId

Template.mirador_scrollView_content.events
  'click .image-instance a': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'imageView',
      manifestId: tpl.data.manifestId
      imageId: @index

