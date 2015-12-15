if Meteor.isClient
  Router.onBeforeAction("loading")

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
    onBeforeAction: () ->
      if !this.ready()
        this.render
    waitOn: () ->
      [
        Meteor.subscribe('availablemanifests'),
        Meteor.subscribe('workspaces'),
        Meteor.subscribe('annotations'),
        Meteor.subscribe('filecabinet'),
        Meteor.subscribe('fileregistry'),
        Meteor.subscribe('opendocs')
      ]
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()
    onStop: ->
      #delete Mirador

  @route 'files',
    path: '/files'
    waitOn: () ->
      [
        Meteor.subscribe('opendocs'),
        Meteor.subscribe('fileregistry')
      ]
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'bookshelf',
    path: '/bookshelf'
    waitOn: () ->
      [
        Meteor.subscribe('bookshelves'),
        Meteor.subscribe('books'),
        Meteor.subscribe('fileregistry')
      ]
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'collaboration',
    path: '/collaboration',
    waitOn: () ->
      [
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
    waitOn: () ->
      [
        Meteor.subscribe('availablemanifests'),
        Meteor.subscribe('workspaces'),
        Meteor.subscribe('annotations'),
        Meteor.subscribe('folioitems')
      ]
    action: ->
      if !Meteor.userId()
        @redirect "home"
      else
        @render()

  @route 'folioEdit',
    path: '/folio/edit'
    waitOn: () ->
      [
        Meteor.subscribe('availablemanifests'),
        Meteor.subscribe('workspaces'),
        Meteor.subscribe('annotations'),
        Meteor.subscribe('folioitems')
      ]
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

  @route 'iiifManifests',
    path: '/manifest/:manifestId/:project?',
    where: 'server',
    action: ->
      manifest = AvailableManifests.findOne({"_id": @params.manifestId})

      #loop through canvases in the payload
      for sequence in manifest.manifestPayload.sequences
        for canvas in sequence.canvases
          annoArr = []
          availAnnos = Annotations.find({"canvas": canvas["@id"], "manifest": @params.manifestId, "project": @params.project}).fetch()
          for anno in availAnnos
            annoArr.push {"@id": process.env.ROOT_URL + "annotations/" + anno["_id"] + ".json", "@type": "sc:AnnotationList"}

          if annoArr.length > 0
            canvas.otherContent = annoArr


      if @params.project
        console.log @params.project
      if @params.project
        manifest.manifestPayload.scriptorium = @params.manifestId + "|" + @params.project
      else
        manifest.manifestPayload.scriptorium = @params.manifestId
      this.response.writeHead(200, {'content-type': 'application/json', 'access-control-allow-origin': '*'})
      this.response.end(JSON.stringify(manifest.manifestPayload))


  @route 'iifAnnotations',
    path: '/annotations/:canvasId',
    where: 'server',
    action: ->

      annotationList = {
        "@context": "http://www.shared-canvas.org/ns/context.json",
        "@id": process.env.ROOT_URL + "annotations/" + @params.canvasId,
        "@type": "sc:AnnotationList",
        "resources": []
      }

      canvasId = (@params.canvasId).split(".")[0]

      annos = Annotations.findOne({"_id": canvasId})


      for i in annos["annotations"]
        annotationList["resources"].push {
          "@type": "oa:Annotation",
          "motivation": "sc:painting",
          "on": annos.canvas + "#xywh=" + Math.floor(i.x) + "," + Math.floor(i.y) + "," + Math.floor(i.w) + "," + Math.floor(i.h),
          "resource": {
            "@type": "cnt:ContentAsText",
            "chars": i.text,
            "format": "text/plain",
            "language": "eng"
          }

        }

      this.response.writeHead(200, {'content-type': 'application/json', 'access-control-allow-origin': '*'})
      this.response.end(JSON.stringify(annotationList))

  @route 'serveFile',
    path: '/file/:filename'
    where: 'server'
    action: FileRegistry.serveFile

  @route 'notFound',
    path: '*'
    where: 'server'
    action: ->
      @response.statusCode = 404
      @response.end Handlebars.templates['404']()
    onBeforeAction: ->
      AccountsEntry.signInRequired(@)
