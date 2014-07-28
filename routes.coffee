Router.map ->
  @route 'home',
    path: '/'
    action: ->
      if Meteor.userId()
        @redirect "desk"
      else
        @render()


  @route 'desk',
    path: '/desk'

  @route 'files',
    path: '/files'

  @route 'collaboration',
    path: '/collaboration'

  @route 'folio',
    path: '/folio'

  @route 'notFound',
    path: '*'
    where: 'server'
    action: ->
      @response.statusCode = 404
      @response.end Handlebars.templates['404']()
    onBeforeAction: ->
      AccountsEntry.signInRequired(@)
