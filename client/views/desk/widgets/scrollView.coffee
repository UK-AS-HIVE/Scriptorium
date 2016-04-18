@miradorWidgetProperties = @miradorWidgetProperties || {}
@miradorWidgetProperties.scrollView =
  title: ->
    'Scroll View : ' + AvailableManifests.findOne(@manifestId).manifestPayload.label
  height: 400
  width: 600
  contentClass: "mirador-widget-content-scroll-view"
  imageLabelHeight: 25
  toolbarHeight: 25

Template.mirador_scrollView_content.onCreated ->
  @images = new ReactiveVar([])

Template.mirador_scrollView_content.onRendered ->
  tpl = @

  @autorun ->
    h = Template.currentData().height - 150
    scrollWidth = 0
    tpl.$('img').height h
    _.each tpl.$('img'), (img) ->
      w = h*Blaze.getData(img).aspectRatio
      $(img).width w
      scrollWidth += w + 10
    tpl.$('.scroll-view-frame').width scrollWidth

  manifest = AvailableManifests.findOne(@data.manifestId).manifestPayload
  thumbHeight = @data.height - 150
  _.each manifest.sequences[0].canvases, (c, idx) ->
    setTimeout ->
      imageInfo = ImageMetadata.findOne({retrievalUrl: c.images[0].resource.service['@id']+'/info.json'}, {reactive: false, fields: {payload: 1}}).payload

      images = tpl.images.get()

      images.push
        index: idx
        title: c.label
        uriWithHeight: miradorFunctions.iiif_getUriWithHeight imageInfo, thumbHeight
        aspectRatio: c.width / c.height
        height: thumbHeight
        width: Math.round(c.width * thumbHeight / c.height)

      tpl.images.set images
    , idx

Template.mirador_scrollView_content.helpers
  images: ->
    Template.instance().images.get()
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

