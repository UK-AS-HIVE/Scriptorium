Router.map ->
  @route 'home',
    path: '/'
    action: ->
      if Meteor.userId()
        @redirect "welcome"
      else
        @render()

  @route 'signUp',
    path: '/signup'

  @route 'welcome',
    path: '/welcome'
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'desk',
    path: '/desk'
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'files',
    path: '/files'
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'bookshelf',
    path: '/bookshelf'
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'collaboration',
    path: '/collaboration',
    waitOn: () ->
      [
        Meteor.subscribe('projects'),
        Meteor.subscribe('collaboration', Session.get('current_project'))
      ]
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'collaborationThread',
    path: '/collaboration/thread/:_id'
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()
    data: () ->
      Messages.findOne({_id: @params._id})

  @route 'folio',
    path: '/folio'
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'folioEdit',
    path: '/folio/edit'
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'folioAPI',
    path :'/folio/manifest.json',
    where: 'server',
    action: ->

      canvases = folioItems.find({"published": true}, {fields: {canvas: 1, _id: 0}}).fetch()
      canvArray = []
      for i of canvases
        canvArray[i] = canvases[i].canvas
        console.log(canvArray[i])

      seqArray = [{"@id": process.env.ROOT_URL + "folio/sequence/normal.json", "@type": "sc:Sequence", "label": "Normal Order", "canvases": canvArray}]

      manifest = {}
      manifest["@id"] = process.env.ROOT_URL + "folio/manifest"
      manifest["@context"] = "http://www.shared-canvas.org/ns/context.json"
      manifest["@type"] = "sc:Manifest"
      manifest["attribution"] = "HMML"
      manifest["description"] = "HMML images for folio"
      manifest["label"] = "Folio Images"
      manifest["metadata"] = []
      manifest["viewingDirection"] = "left-to-right"
      manifest["viewingHint"] = "paged"
      manifest["sequences"] = seqArray


      this.response.writeHead(200, {'content-type': 'application/json', 'access-control-allow-origin': '*'})
      this.response.end(JSON.stringify(manifest))

  @route 'notFound',
    path: '*'
    where: 'server'
    action: ->
      @response.statusCode = 404
      @response.end Handlebars.templates['404']()
    onBeforeAction: ->
      AccountsEntry.signInRequired(@)
