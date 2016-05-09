defaults =
  # Router.configure behavior is completely unpredictable, so we use a defaults object.
  onBeforeAction: ->
    if !Meteor.userId() and FlowRouter.route.getName() isnt 'signUp'
      @redirect 'home'
    @next()
  waitOn: ->
    if Meteor.userId()
      [
        Meteor.subscribe 'projects'
        Meteor.subscribe 'project', Session.get('current_project')
      ]

if Meteor.isClient
  Tracker.autorun ->
    if Meteor.userId()
      Meteor.subscribe 'projects'
      Meteor.subscribe 'project', Session.get('current_project')

###
Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: '404'
  yieldTemplates:
    header:
      to: 'header'
    footer:
      to: 'footer'
###

if Meteor.isClient
  Meteor.startup ->
    Tracker.autorun ->
      if Meteor.userId()
        FlowRouter.go '/welcome'

FlowRouter.route '/',
  name: 'home'
  action: ->
    if Meteor.userId()
      FlowRouter.go 'welcome'
    else
      BlazeLayout.render 'layout',
        content: 'home'

FlowRouter.route '/signUp',
  name: 'signUp'
  action: ->
    BlazeLayout.render 'layout',
      content: 'signUp'

FlowRouter.route '/signUp/:id',
  name: 'approvedSignup'
  onBeforeAction: ->
    if Meteor.userId()
      @redirect 'welcome'
    else
      @next()
  waitOn: -> Meteor.subscribe 'requestedAccountForSignup', @params.id
  data: -> RequestedAccounts.findOne @params.id

FlowRouter.route '/pendingAccounts',
  name: 'pendingAccounts',
  onBeforeAction: defaults.onBeforeAction
  subscriptions: ->
    Meteor.subscribe 'requestedAccounts'

FlowRouter.route '/signOut',
  name: 'signOut'
  action: ->
    Meteor.logout()
    Accounts.makeClientLoggedOut()
    localStorage.clear()
    FlowRouter.go('/')

FlowRouter.route '/welcome',
  name: 'welcome'
  action: ->
    BlazeLayout.render 'layout',
      content: 'welcome'
  
FlowRouter.route '/desk',
  name: 'desk'
  action: ->
    BlazeLayout.render 'layout',
      content: 'desk'
  waitOn: defaults.waitOn
  onBeforeAction: defaults.onBeforeAction

FlowRouter.route '/files',
  name: 'files'
  action: ->
    BlazeLayout.render 'layout',
      content: 'files'
  waitOn: defaults.waitOn
  onBeforeAction: defaults.onBeforeAction

FlowRouter.route '/bookshelf',
  name: 'bookshelf'
  action: ->
    BlazeLayout.render 'layout',
      content: 'bookshelf'
  waitOn: defaults.waitOn
  onBeforeAction: defaults.onBeforeAction

FlowRouter.route '/collaboration',
  name: 'collaboration'
  action: ->
    BlazeLayout.render 'layout',
      content: 'collaboration'
  waitOn: defaults.waitOn
  onBeforeAction: defaults.onBeforeAction
  action: ->
    if Projects.findOne(Session.get('current_project'))?.personal is Meteor.userId()
      @redirect 'welcome'
      @next()
    else
      @render()

FlowRouter.route '/collaboration/thread/:_id',
  name: 'collaborationThread'
  action: ->
    BlazeLayout.render 'layout',
      content: 'collaborationThread'
  waitOn: defaults.waitOn
  onBeforeAction: defaults.onBeforeAction
  data: ->
    Messages.findOne @params._id

FlowRouter.route '/folio',
  name: 'folio'
  action: ->
    BlazeLayout.render 'layout',
      content: 'folio'
  waitOn: defaults.waitOn
  onBeforeAction: defaults.onBeforeAction

FlowRouter.route '/folio/edit',
  name: 'folioEdit'
  action: ->
    BlazeLayout.render 'layout',
      content: 'folioEdit'
  waitOn: defaults.waitOn
  onBeforeAction: defaults.onBeforeAction

FlowRouter.route '/folio/manifest.json',
  name: 'folioAPI'
  where: 'server'
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

FlowRouter.route '/manifest/:manifestId/:project?',
  name: 'iiifManifests'
  where: 'server'
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


FlowRouter.route '/annotations/:canvasId',
  name: 'iifAnnotations'
  where: 'server'
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

FlowRouter.route '/file/:filename',
  name: 'serveFile'
  where: 'server'
  action: FileRegistry.serveFile

if Meteor.isServer
  WebApp.connectHandlers.use '/export/annotations/', (req, res, next) ->
    [..., projectId, manifestId, canvasIndex] = req.url.split('/')
    {exportAnnotations} = require '/imports/server/exportAnnotations.coffee'
    exportAnnotations projectId, manifestId, parseInt(canvasIndex), res

