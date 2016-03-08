Template.mirador_mainMenu.onRendered ->
  loadWindowContent = $('<div/>')
  Blaze.render(Template.mirador_mainMenu_loadWindowContent, loadWindowContent.get(0))
  # menu 'Load Window'
  @.$('.load-window').tooltipster
    arrow: true
    content: loadWindowContent
    contentCloning: false
    interactive: true
    position: 'bottom'
    theme: '.tooltipster-mirador'

    functionReady: (origin, continueTooltip) ->
      ###
      heightTooltipster = jQuery('.mirador-viewer').height() * 0.8

      jQuery('.mirador-listing-collections').height(heightTooltipster);
      jQuery('.mirador-listing-collections ul').height(heightTooltipster - 70)
      ###

  # Window Options
  windowOptions = $('<div/>')
  Blaze.render(Template.mirador_mainMenu_windowOptionsMenu, windowOptions.get(0))
  @.$('.window-options').tooltipster
    arrow: true
    content: windowOptions
    contentCloning: false
    interactive: true
    theme: '.tooltipster-mirador'

  # menu 'Clear Local Storage'
  clearLocalStorage = $('<div/>')
  Blaze.render(Template.mirador_mainMenu_clearLocalStorage, clearLocalStorage.get(0))
  @.$('.clear-local-storage').tooltipster
    arrow: true
    content: clearLocalStorage
    contentCloning: false
    interactive: true
    theme: '.tooltipster-mirador'

Template.mirador_mainMenu.events
  'click .bookmark-workspace': ->
    #TODO

Template.mirador_mainMenu_loadWindowContent.helpers
  imageIndex: ->
    Template.parentData(1).manifestPayload.sequences[0].canvases.indexOf(this)
  collections: ->
    return AvailableManifests.find()
  imageData: ->
    @manifestPayload.sequences[0].canvases

Template.mirador_mainMenu_menuItems.events
  "click .js-toggle-desk-panel": ->
    $('.desk-document-panel').toggleClass('is-open')

Template.mirador_mainMenu_loadWindowContent.events
  # attach onChange event handler for collections select list
  'change .mirador-listing-collections select': (e, tpl) ->
    manifestId = tpl.$('option:selected').data('manifest-id')

    tpl.$('.mirador-listing-collections ul').hide()
    tpl.$('.mirador-listing-collections ul.ul-'+manifestId).show()

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

Template.mirador_mainMenu_windowOptionsMenu.events
  'click .window-options-menu .cascade-all': ->
    widgets = ActiveWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      ActiveWidgets.update aw._id,
        $set:
          x: 5 + 25*i
          y: 5 + 25*i

  'click .window-options-menu .tile-all-vertically': ->
    deskHeight = $('.mirador-viewer').height() - 45
    deskWidth = $('.mirador-viewer').width() - 5
    widgets = ActiveWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      ActiveWidgets.update aw._id,
        $set:
          x: 5
          y: 5+i*(deskHeight/widgetCount)
          width: deskWidth - 10
          height: deskHeight/widgetCount - 5

  'click .window-options-menu .tile-all-horizontally': ->
    deskHeight = $('.mirador-viewer').height() - 45
    deskWidth = $('.mirador-viewer').width() - 5
    widgets = ActiveWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      ActiveWidgets.update aw._id,
        $set:
          x: 5+i*(deskWidth/widgetCount)
          y: 5
          width: deskWidth/widgetCount - 5
          height: deskHeight - 10

  'click .window-options-menu .stack-all-vertically-2-cols': ->
    deskHeight = $('.mirador-viewer').height() - 45
    deskWidth = $('.mirador-viewer').width() - 5
    widgets = ActiveWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      ActiveWidgets.update aw._id,
        $set:
          x: 5+(i%2)*(deskWidth/2)
          y: 5+Math.floor(i/2)*(deskHeight/Math.ceil(widgetCount/2))
          width: deskWidth/2 - 5
          height: deskHeight/Math.ceil(widgetCount/2) - 5

  'click .window-options-menu .stack-all-vertically-3-cols': ->
    deskHeight = $('.mirador-viewer').height() - 45
    deskWidth = $('.mirador-viewer').width() - 5
    widgets = ActiveWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      ActiveWidgets.update aw._id,
        $set:
          x: 5+(i%3)*(deskWidth/3)
          y: 5+Math.floor(i/3)*(deskHeight/Math.ceil(widgetCount/3))
          width: deskWidth/3 - 5
          height: deskHeight/Math.ceil(widgetCount/3) - 5

  'click .window-options-menu .close-all': ->
    ActiveWidgets.find().forEach (aw) ->
      ActiveWidgets.remove aw._id

Template.mirador_mainMenu_clearLocalStorage.events
  'click button[data-action=cancel]': ->
    $('.clear-local-storage').tooltipster('hide')

  'click button[data-action=clear]': (e, tpl) ->
    ActiveWidgets.find().forEach (aw) ->
      ActiveWidgets.remove aw._id
    $('.clear-local-storage').tooltipster('hide')
