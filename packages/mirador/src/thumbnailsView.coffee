@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.thumbnailsView =
  label: 'Thumbnails View'
  title: ->
    'Thumbnails View : ' + AvailableManifests.findOne(@manifestId).manifestPayload.label
  height: 400
  width: 600
  thumbsMaxHeight: 150
  thumbsMinHeight: 50
  thumbsDefaultZoom: 0.5

Template.mirador_thumbnailsView_listImages.helpers
  thumbs: ->
    _.map @imagesList, (image, index) ->
      {
        thumbUrl: $.Iiif.getUriWithHeight(image.imageUrl, _this.thumbsMaxHeight),
        title:    image.title,
        id:       image.id
      }

Template.mirador_thumbnailsView_listImages.events
  'click .listing-thumbs li a': (e, tpl) ->
    $.view.loadView _this.manifestId, $(e.target).data('image-id')

  'slide': (e, ui, tpl) ->
    # Not sure how jquery UI handles these events - might have to put them in onRendered
    $(e.target).attr('height', ui.value)


Template.mirador_thumbnailsView_navToolbar.events
  'click .mirador-icon-metadata-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'metaDataView', _this.manifestId

  'click .mirador-icon-scroll-view': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'scrollView', _this.manifestId

