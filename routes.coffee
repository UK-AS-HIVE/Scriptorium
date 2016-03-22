Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  yieldTemplates:
    header:
      to: 'header'
    footer:
      to: 'footer'
  onBeforeAction: ->
    if !Meteor.userId() and @route.getName() isnt 'signUp'
      @redirect 'home'
      @next()
    else
      @next()
  waitOn: ->
    if Meteor.userId()
      [
        Meteor.subscribe 'projects'
        Meteor.subscribe 'project', Session.get('current_project')
      ]

Router.map ->
  @route 'home',
    path: '/'
    action: ->
      if Meteor.userId()
        @redirect 'welcome'
      else
        @render()

  @route 'signUp',
    path: '/signup'

  @route 'welcome',
    path: '/welcome'

  @route 'desk',
    path: '/desk'

  @route 'files',
    path: '/files'

  @route 'bookshelf',
    path: '/bookshelf'

  @route 'collaboration',
    path: '/collaboration',
    action: ->
      if Projects.findOne(Session.get('current_project'))?.personal is Meteor.userId()
        @redirect 'welcome'
        @next()
      else
        @render()

  @route 'collaborationThread',
    path: '/collaboration/thread/:_id'
    data: ->
      Messages.findOne @params._id

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

      seqArray = [{"@id": Meteor.absoluteUrl("folio/sequence/normal.json"), "@type": "sc:Sequence", "label": "Normal Order", "canvases": canvArray}]

      manifest = {}
      manifest["@id"] = Meteor.absoluteUrl "folio/manifest"
      manifest["@context"] = "http://www.shared-canvas.org/ns/context.json"
      manifest["@type"] = "sc:Manifest"
      manifest["attribution"] = "HMML"
      manifest["description"] = "HMML images for folio"
      manifest["label"] = "Folio Images"
      manifest["metadata"] = []
      manifest["viewingDirection"] = "left-to-right"
      manifest["viewingHint"] = "paged"
      manifest["sequences"] = seqArray


      @response.writeHead(200, {'content-type': 'application/json', 'access-control-allow-origin': '*'})
      @response.end(JSON.stringify(manifest))

  @route 'iiifManifests',
    path: '/manifest/:manifestId/:project?',
    where: 'server',
    action: ->
      manifest = AvailableManifests.findOne(@params.manifestId)

      #loop through canvases in the payload
      for sequence in manifest.manifestPayload.sequences
        for canvas in sequence.canvases
          annoArr = []
          availAnnos = Annotations.find({"canvas": canvas["@id"], "manifest": @params.manifestId, "project": @params.project}).fetch()
          for anno in availAnnos
            annoArr.push {"@id": Meteor.absoluteUrl("annotations/#{anno._id}.json"), "@type": "sc:AnnotationList"}

          if annoArr.length > 0
            canvas.otherContent = annoArr


      if @params.project
        console.log @params.project
        manifest.manifestPayload.scriptorium = @params.manifestId + "|" + @params.project
      else
        manifest.manifestPayload.scriptorium = @params.manifestId
      @response.writeHead(200, {'content-type': 'application/json', 'access-control-allow-origin': '*'})
      @response.end(JSON.stringify(manifest.manifestPayload))


  @route 'iifAnnotations',
    path: '/annotations/:canvasId',
    where: 'server',
    action: ->

      annotationList = {
        "@context": "http://www.shared-canvas.org/ns/context.json",
        "@id": Meteor.absoluteUrl("annotations/" + @params.canvasId),
        "@type": "sc:AnnotationList",
        "resources": []
      }

      canvasId = (@params.canvasId).split(".")[0]

      annos = Annotations.findOne({"_id": canvasId})

      for i in annos["annotations"]
        annotationList["resources"].push {
          "@type": "oa:Annotation",
          motivation: "sc:painting",
          on: annos.canvas + "#xywh=" + Math.floor(i.x) + "," + Math.floor(i.y) + "," + Math.floor(i.w) + "," + Math.floor(i.h),
          resource: {
            "@type": "cnt:ContentAsText",
            chars: i.text,
            format: "text/plain",
            language: "eng"
          }

        }

      @response.writeHead(200, {'content-type': 'application/json', 'access-control-allow-origin': '*'})
      @response.end(JSON.stringify(annotationList))

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
