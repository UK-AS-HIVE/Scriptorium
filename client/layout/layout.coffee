Template.layout.onRendered ->
  $(window).on 'keyup', (e) ->
    if e.keyCode is 27
      $('.modal:visible').modal('hide')
      $('.is-open').removeClass('is-open')
