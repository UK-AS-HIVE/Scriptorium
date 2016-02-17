Template.helpPanel.events
  "click .js-close-panel": ->
    $('.help-panel').removeClass('is-open')

  "click [data-action=showContent]": (e, tpl) ->
    Blaze.renderWithData Template.helpModal, { feature: tpl.$(e.target).data('feature') }, $('body').get(0)
    $("#helpModal").modal("show")

Template.helpModal.events
  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view

Template.helpModal.helpers
  template: ->
    "help_" + @feature
