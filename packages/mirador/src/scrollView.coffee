@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.scrollView =
  title: ->
    'Scroll View : ' + AvailableManifests.findOne(@manifestId).manifestPayload.label
  height: 400
  width: 600
  imageLabelHeight: 25
  toolbarHeight: 25

Template.mirador_scrollView_content.helpers
  images: ->
    console.log 'mirador_scrollView_listImages.images', @
    _.map AvailableManifests.findOne(@manifestId).manifestPayload.sequences[0].canvases, (c) ->
      uriWithHeight: miradorFunctions.iiif_getUriWithHeight c.images[0].resource.service[@id], 216

