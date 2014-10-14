Template.mbBoard.helpers({
  topics: () ->
    Messages.find({roomId: Session.get("current_project")}, {sort: {"posts.timestamp": -1}}).fetch()
})


Template.mbBoard.events({
    'click #newTopicModal .save': (e,t) ->
      projectId = Session.get("current_project")
      subject = t.$(".subject").val()
      message = t.$(".message").val()
      #save new message
      console.log('save', projectId, subject, message)
      Meteor.call('addThread', projectId, subject, message)
      #route the user to it
      $('#newTopicModal').modal('hide')

    'submit #newTopicModal form': (e) ->
      e.preventDefault()
      console.log('submit')
})


Template.timeago.rendered = (a,b,c) ->
  Tracker.autorun(() ->
    messages = Messages.find().fetch()

    @$('.timeago').timeago('updateFromDOM')
    @$('.timeago').timeago()
  )
  #console.log('rendered', @, a,b,c, @$)

  #console.log('rendered')

Template.timeago.helpers({
  pretty: () ->
    #console.log('pretty', @)
    moment(@).format('MMMM D, YYYY')

  timestamp: () ->
    moment(@).format()
})
