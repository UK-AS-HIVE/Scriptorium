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
  images: ->
    manifest = AvailableManifests.findOne(@manifestId).manifestPayload
    thumbHeight = @height - 150
    _.map manifest.sequences[0].canvases, (c, idx) ->
      imageInfo = ImageMetadata.findOne({retrievalUrl: c.images[0].resource.service['@id']+'/info.json'}, {reactive: false}).payload
      index: idx
      title: c.label
      uriWithHeight: miradorFunctions.iiif_getUriWithHeight imageInfo, thumbHeight
      height: thumbHeight
      width: Math.round(c.width * thumbHeight / c.height)
  scrollWidth: ->
    return _.reduce @, ((memo,img) -> memo+img.width + 10), 0
  scrollHeight: ->
    @height - 70

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

