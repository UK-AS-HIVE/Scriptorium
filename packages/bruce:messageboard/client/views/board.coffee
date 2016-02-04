Template.mbBoard.helpers
  topics: ->
    Messages.forRoom(Session.get("current_project"), Session.get('message_search')).fetch()

  searchText: ->
    Session.get('message_search')

Template.mbBoard.events
  'shown.bs.modal #newTopicModal': (e, tpl) ->
    $('#newTopicModal input').first().focus()

  'click #newTopicModal .save': (e, tpl) ->
    projectId = Session.get("current_project")
    subject = tpl.$('.subject').val()
    message = tpl.$('.message').val()
    # save new message
    Meteor.call 'addThread', projectId, subject, message, (err, res) ->
      unless err
        tpl.$('.subject').val('')
        tpl.$('.message').val('')
    # route the user to it
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

Template.timeago.rendered = (a,b,c) ->
  @autorun ->
    messages = Messages.find().fetch()
    @$('.timeago').timeago('updateFromDOM')
    @$('.timeago').timeago()

Template.timeago.helpers
  pretty: ->
    moment(@).format('MMMM D, YYYY')

  timestamp: ->
    moment(@).format()
