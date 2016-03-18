Template.deskPanel.events
  "click .js-close-panel": (e, tpl) ->
    tpl.$('.desk-panel').removeClass('is-open')
