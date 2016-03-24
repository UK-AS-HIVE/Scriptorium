Template.chatPanel.events
  'click .js-close-panel': (e, tpl) ->
    tpl.$('#desk-chat-panel').removeClass('is-open')

  'keyup input[name=chat]': (e, tpl) ->
    if e.keyCode is 13
      tpl.$('button[data-action=send]').click()

  'click button[data-action=send]': (e, tpl) ->
    if tpl.$('input[name=chat]').val().length
      EventStream.insert
        projectId: Session.get('current_project')
        userId: Meteor.userId()
        type: 'chat'
        message: tpl.$('input[name=chat]').val()

      tpl.$('input[name=chat]').val('')
      tpl.$('.chat-area').scrollTop tpl.$('.chat-area')[0].scrollHeight

  'click button[data-action=loadSnapshot]': (e, tpl) ->
    Meteor.call 'loadDeskSnapshot', @otherId

  'click button[data-action=loadImage]': (e, tpl) ->
    annotation = Annotations.findOne(@otherId)
    miradorFunctions.mirador_viewer_loadView 'imageView',
      manifestId: annotation.manifestId
      imageId: annotation.canvasIndex
      annotationPanelOpen: true

  'click button[data-action=loadDocument]': (e, tpl) ->
    miradorFunctions.mirador_viewer_loadView 'editorView',
      fileCabinetId: @otherId

  'click .dropdown-menu': (e, tpl) ->
    # Prevent dropdown from closing on click
    e.stopPropagation()

  'change .checkbox': (e, tpl) ->
    filter = []
    tpl.$(':checked').each ->
      filter.push tpl.$(this).val()
    tpl.filter.set filter
    Meteor.setTimeout ->
      tpl.$('.chat-area').scrollTop tpl.$('.chat-area')[0].scrollHeight
    , 100 # Giving a little time for messages to render.


Template.chatPanel.helpers
  events: -> EventStream.find { type: { $in: Template.instance().filter.get() } }, { sort: { timestamp: 1 } }
  eventIsType: (type) -> @type is type
  snapshot: -> DeskSnapshots.findOne(@otherId)?
  manifest: -> AvailableManifests.findOne(@otherId)?
  file: -> FileCabinet.findOne(@otherId)?
  fileIsType: (type) -> @fileType is type
  annotation: -> Annotations.findOne(@otherId)?
  fullName: -> User.first(@userId)?.fullName()
  addedUserFullName: -> User.first(@otherId).fullName()

Template.chatPanel.onCreated ->
  @filter = new ReactiveVar [ 'deskSnapshots', 'filecabinet', 'annotations', 'availablemanifests', 'chat', 'user' ]

Template.chatPanel.onRendered ->
  tpl = @
  EventStream.find().observe
    added: ->
      if tpl.$('.chat-area')[0]?.scrollHeight - tpl.$('.chat-area').scrollTop() < $(window).height() or
      tpl.$('.chat-area').scrollTop() is 0 and not tpl.$('#desk-chat-panel').hasClass('is-open')
        tpl.$('.chat-area').scrollTop tpl.$('.chat-area')[0].scrollHeight

