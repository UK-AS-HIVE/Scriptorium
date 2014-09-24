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
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'files',
    path: '/files'

  @route 'bookshelf',
    path: '/bookshelf'

  @route 'collaboration',
    path: '/collaboration'

  @route 'folio',
    path: '/folio'

  @route 'folioEdit',
    path: '/folio/edit'

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


      this.response.writeHead(200, {'content-type': 'application/json'})
      this.response.end(JSON.stringify(manifest))

  @route 'notFound',
    path: '*'
    where: 'server'
    action: ->
      @response.statusCode = 404
      @response.end Handlebars.templates['404']()
    onBeforeAction: ->
      AccountsEntry.signInRequired(@)
