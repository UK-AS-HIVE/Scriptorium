Template.mirador_mainMenu.onRendered ->
  j = $('<div/>')
  k = Blaze.render(Template.mirador_mainMenu_loadWindowContent, j.get(0))
  # menu 'Load Window'
  @.$('.load-window').tooltipster
    arrow: true,
    content: j,
    contentCloning: false,
    interactive: true,
    position: 'bottom',
    theme: '.tooltipster-mirador',

    functionReady: (origin, continueTooltip) ->
      ###
      heightTooltipster = jQuery('.mirador-viewer').height() * 0.8

      jQuery('.mirador-listing-collections').height(heightTooltipster);
      jQuery('.mirador-listing-collections ul').height(heightTooltipster - 70)
      ###

Template.mirador_mainMenu_loadWindowContent.helpers
  collections: ->
    return AvailableManifests.find()
  imageData: ->
    if @manifestPayload.sequences.length == 0
      return []
    return @manifestPayload.sequences[0].canvases

Template.mirador_mainMenu_loadWindowContent.events
  'change .mirador-listing-collections select': (e, tpl) ->
    manifestId = tpl.$('option:selected').data('manifest-id')

    tpl.$('.mirador-listing-collections ul').hide()
    tpl.$('.mirador-listing-collections ul.ul-'+manifestId).show()
  'click .mirador-listing-collections ul': (e, tpl) ->
    #TODO

