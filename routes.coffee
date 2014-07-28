Router.map ->
  @route 'home',
    path: '/'

  @route 'dashboard',
    path: '/dashboard'

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
