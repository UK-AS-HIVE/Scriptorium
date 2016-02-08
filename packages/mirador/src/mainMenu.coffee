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
    contentCloning: true
    interactive: true
    theme: '.tooltipster-mirador'

Template.mirador_mainMenu.events
  'click .bookmark-workspace': ->
    #TODO

Template.mirador_mainMenu_loadWindowContent.helpers
  collections: ->
    return AvailableManifests.find()
  imageData: ->
    if @manifestPayload.sequences.length == 0
      return []
    imagesList = []
    _.each @manifestPayload.sequences[0].canvases, (canvas) ->
      images = []
      if canvas['@type'] is 'sc:Canvas'
        images = canvas.resources || canvas.images
        _.each images, (image) ->
          if image['@type'] is 'oa:Annotation'
            imageObj =
              height:       image.resource.height || 0,
              width:        image.resource.width || 0,
              id:           miradorFunctions.genUUID()
              imageUrl:     image.resource.service['@id'].replace(/\/$/, ''),
              choices:      [],
              choiceLabel:  image.resource.label || 'Default'
              title:        canvas.label || ''
              canvasWidth:  canvas.width
              canvasHeight: canvas.height
              canvasId:     canvas['@id']
            
            imageObj.aspectRatio = imageObj.width / imageObj.height || 1
            if canvas.otherContent
              imageObj.annotations = _.map canvas.otherContent, (a) ->
                if a['@id'].indexOf('.json') >= 0
                  return a['@id']
                return a['@id'] + '.json'

            imagesList.push imageObj
    return imagesList



Template.mirador_mainMenu_loadWindowContent.events
  # attach onChange event handler for collections select list
  'change .mirador-listing-collections select': (e, tpl) ->
    manifestId = tpl.$('option:selected').data('manifest-id')

    tpl.$('.mirador-listing-collections ul').hide()
    tpl.$('.mirador-listing-collections ul.ul-'+manifestId).show()

  # attach click event handler for images in the list
  'click .mirador-listing-collections li': (e, tpl) ->
    elemTarget = tpl.$(e.target)
    manifestId = elemTarget.data('manifest-id')
    imageId = elemTarget.data('image-id')
    openAt = null

    # TODO: This should be configurable
    miradorFunctions.mirador_viewer_loadView "imageView", manifestId, @

  # attach click event for thumbnails view icon
  'click .mirador-listing-collections a.mirador-icon-thumbnails-view': (e, tpl) ->
    manifestId = tpl.$('.mirador-listing-collections select').find('option:selected').data('manifest-id')

    $.viewer.loadView("thumbnailsView", manifestId)

  'click .mirador-listing-collections a.mirador-add-mani': (e, tpl) ->
    # Meteor.miradorFunctions.addMani();
    console.log("load manifest")

  # attach click event for scroll view icon
  'click .mirador-listing-collections a.mirador-icon-scroll-view': (e, tpl) ->
    manifestId = tpl.$('.mirador-listing-collections select').find('option:selected').data('manifest-id')

    $.viewer.loadView("scrollView", manifestId)

  # attach click event for metadata view icon
  'click .mirador-listing-collections a.mirador-icon-metadata-view': (e, tpl) ->
    manifestId = tpl.$('.mirador-listing-collections-select').find('option:selected').data('manifest-id')

    $.viewer.loadView("metadataView", manifestId)

Template.mirador_mainMenu_windowOptionsMenu.events
  'click .window-options-menu .cascade-all': ->
    $.viewer.layout.applyLayout('cascade')

  'click .window-options-menu .tile-all-vertically': ->
    $.viewer.layout.applyLayout('tileAllVertically')

  'click .window-options-menu .tile-all-horizontally': ->
    $.viewer.layout.applyLayout('tileAllHorizontally')

  'click .window-options-menu .stack-all-vertically-2-cols': ->
    $.viewer.layout.applyLayout('stackAll2Columns')

  'click .window-options-menu .stack-all-vertically-3-cols': ->
    $.viewer.layout.applyLayout('stackAll3Columns')

  'click .window-options-menu .close-all': ->
    $.viewer.layout.closeAll()

