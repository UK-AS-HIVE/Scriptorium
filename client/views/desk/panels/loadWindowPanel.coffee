Template.loadWindowPanel.onCreated ->
  @selectedCollectionId = new ReactiveVar(AvailableManifests.findOne()?._id)

Template.loadWindowPanel.helpers
  imageIndex: ->
    Template.parentData(1).manifestPayload.sequences[0].canvases.indexOf(this)
  collectionLocations: ->
    _.uniq _.pluck AvailableManifests.find().fetch(), 'manifestLocation'
  manifestsByLocation: ->
    AvailableManifests.find { manifestLocation: @valueOf() }
  selectedCollection: ->
    AvailableManifests.findOne(Template.instance().selectedCollectionId.get()) || AvailableManifests.findOne()
  imageData: ->
    @manifestPayload.sequences[0].canvases
  trimTitlePrefix: (title) ->
    title = title.replace(/^Beinecke MS \w+,? \[?/, '')
    title = title.replace(/\]$/, '')
    return title

Template.loadWindowPanel.events
  # attach onChange event handler for collections select list
  'change .mirador-listing-collections select': (e, tpl) ->
    manifestId = tpl.$('option:selected').data('manifest-id')
    tpl.selectedCollectionId.set manifestId

  # attach click event handler for images in the list
  'click .mirador-listing-collections li a': (e, tpl) ->
    elemTarget = tpl.$(e.target)
    manifestId = elemTarget.data('manifest-id')
    imageId = elemTarget.data('image-id')
    openAt = null

    # TODO: This should be configurable
    miradorFunctions.mirador_viewer_loadView "imageView",
      manifestId: manifestId
      imageId: tpl.$(e.target).data('image-id')

  'click .mirador-listing-collections a.mirador-icon-add-mani': (e, tpl) ->
    Blaze.render Template.addManifestModal, $('body').get(0)
    $('#addManifestModal').modal('show')

  # attach click event for thumbnails view icon
  'click .mirador-listing-collections a.mirador-icon-thumbnails-view': (e, tpl) ->
    manifestId = tpl.$('.mirador-listing-collections select').find('option:selected').data('manifest-id')

    miradorFunctions.mirador_viewer_loadView "thumbnailsView",
      manifestId: manifestId

  # attach click event for scroll view icon
  'click .mirador-listing-collections a.mirador-icon-scroll-view': (e, tpl) ->
    manifestId = tpl.$('.mirador-listing-collections select').find('option:selected').data('manifest-id')

    miradorFunctions.mirador_viewer_loadView "scrollView",
      manifestId: manifestId

  # attach click event for metadata view icon
  'click .mirador-listing-collections a.mirador-icon-metadata-view': (e, tpl) ->
    manifestId = tpl.$('.mirador-listing-collections select').find('option:selected').data('manifest-id')

    miradorFunctions.mirador_viewer_loadView "metadataView",
      manifestId: manifestId

  'click .mirador-listing-collections a.mirador-icon-del-mani': (e, tpl) ->
    manifestId = tpl.$('.mirador-listing-collections select').find('option:selected').data('manifest-id')
    Blaze.renderWithData Template.deleteManifestModal, { manifestId: manifestId }, $('body').get(0)
    $('#deleteManifestModal').modal('show')
