Template.helpPanel.helpers
  template: ->
    "help_" + Router.current().route.getName()

Template.helpPanel.events
  "click .js-close-panel": ->
    $('.help-panel').removeClass('is-open')

  "click [data-action=showContent]": (e, tpl) ->
    Blaze.renderWithData Template.helpModal, { feature: tpl.$(e.target).data('feature') }, $('body').get(0)
    $("#helpModal").modal("show")
