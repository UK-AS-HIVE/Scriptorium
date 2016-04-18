Template.mbBoard.helpers
  canDeleteThread: ->
    project = Projects.findOne {
      _id: Session.get('current_project'),
      permissions: { $elemMatch: { user: Meteor.userId(), level: 'admin' } }
    }

    @startedBy is Meteor.userId() or project?
  onlyOnePost: ->
    @posts.length is 1
  postCount: ->
    @posts.length
  fullName: (userId) ->
    user = User.first userId
    if user then user.fullName() else ""
  lastPost: ->
    if @posts
      _.sortBy(@posts, (p) -> -p.timestamp)[0]
  topics: ->
    searchText = Session.get('message_search') || ''
    search = { $regex: ".*#{searchText}.*", $options: 'i' }
    Messages.find {
      roomId: Session.get "current_project"
      $or: [
        { subject: search }
        { 'posts.message': search }
      ]
    }
    , { sort: { timestamp: -1 } }

  searchText: ->
    Session.get('message_search')

Template.mbBoard.events
  'shown.bs.modal #newTopicModal': (e, tpl) ->
    $('#newTopicModal input').first().focus()

  'hidden.bs.modal #newTopicModal': (e, tpl) ->
    tpl.$('.has-error').removeClass('has-error')

  'click #newTopicModal .save': (e, tpl) ->
    projectId = Session.get("current_project")
    subject = tpl.$('.subject').val()
    message = tpl.$('.message').val()
    if not subject
      tpl.$('.subject').closest('.form-group').addClass('has-error')
    if not message
      tpl.$('.message').closest('.form-group').addClass('has-error')
    if subject and message
      Meteor.call 'addThread', projectId, subject, message, (err, res) ->
        unless err
          tpl.$('.has-error').removeClass('has-error')
          tpl.$('.subject').val('')
          tpl.$('.message').val('')
          $('#newTopicModal').modal('hide')

  'submit #newTopicModal form': (e) ->
    e.preventDefault()

  'click #newTopicModal .closeMe': (e, tpl) ->
    tpl.$('input, textarea').val('')

  'click .newTopic': (e) ->
    e.preventDefault()

  'keyup .search input': (e, tpl) ->
    searchText = tpl.$('input').val()
    Session.set('message_search', searchText)

  'click a[data-action=deleteThread]': (e, tpl) ->
    Blaze.renderWithData Template.mbDeleteThreadModal, { postId: @_id }, $('body').get(0)
    $('#mbDeleteThreadModal').modal('show')

  'click a[data-action=clear]': ->
    Session.set 'message_search', null

Template.mbDeleteThreadModal.events
  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view
  'click button[data-action=delete]': (e, tpl) ->
    Meteor.call 'deleteThread', tpl.data.postId
    tpl.$('#mbDeleteThreadModal').modal('hide')
