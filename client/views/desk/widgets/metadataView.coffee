@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.metadataView =
  label: 'Metadata View'
  title: ->
    'Metadata View : ' + AvailableManifests.findOne(@manifestId).manifestPayload.label
  height: 400
  width: 600

Template.mirador_metadataView_content.helpers
  metadata: ->
    # TODO: addLinksToUris
    AvailableManifests.findOne(@manifestId).manifestPayload

Template.mirador_metadataView_navToolbar.events
  'click .mirador-icon-scroll-view': ->
    miradorFunctions.mirador_viewer_loadView 'scrollView',
      manifestId: @manifestId
  'click .mirador-icon-thumbnails-view': ->
    miradorFunctions.mirador_viewer_loadView 'thumbnailsView',
      manifestId: @manifestId

