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

# Optimization: would prefer to do this using {{#each...}}, but
# since Blaze renders synchronously, that blocks the event loop for far too long,
# and freezes the browser.  Instead, spread out adding these nodes to the DOM over
# time.
Template.mirador_thumbnailsView_listImages.onRendered ->
  tpl = @
  manifest = AvailableManifests.findOne(@data.manifestId).manifestPayload
  _.each manifest.sequences[0].canvases, (c, index) ->
    Meteor.setTimeout ->
      imageInfo = ImageMetadata.findOne({retrievalUrl: c.images[0].resource.service['@id']+'/info.json'}).payload
      data =
        thumbUrl: miradorFunctions.iiif_getUriWithHeight imageInfo, 150
        title:    c.label
        id:       index
        width:    imageInfo.width * (150 / imageInfo.height)

      Blaze.renderWithData Template.mirador_thumbnailsView_thumb, data, tpl.$('ul.listing-thumbs').get(0)
    , index

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

