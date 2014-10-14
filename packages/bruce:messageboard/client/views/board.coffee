Template.mbBoard.rendered = () ->
  $('#newTopicModal').on('shown.bs.modal', () ->
    $('#newTopicModal input').first().focus();
  )

Template.mbBoard.helpers({
  topics: () ->
    Messages.forRoom(Session.get("current_project")).fetch()
})


Template.mbBoard.events({
    'click #newTopicModal .save': (e,t) ->
      projectId = Session.get("current_project")
      subject = t.$(".subject").val()
      message = t.$(".message").val()
      #save new message
      Meteor.call('addThread', projectId, subject, message)
      #route the user to it
      $('#newTopicModal').modal('hide')

    'submit #newTopicModal form': (e) ->
      e.preventDefault()
      console.log('submit')

    'click #newTopicModal .closeMe': (e, t) ->
      t.$('input, textarea').val('')

    'click .newTopic': (e) ->
      e.preventDefault()
})


Template.timeago.rendered = (a,b,c) ->
  Tracker.autorun(() ->
    messages = Messages.find().fetch()

    @$('.timeago').timeago('updateFromDOM')
    @$('.timeago').timeago()
  )

Template.timeago.helpers({
  pretty: () ->
    moment(@).format('MMMM D, YYYY')

  timestamp: () ->
    moment(@).format()
})
