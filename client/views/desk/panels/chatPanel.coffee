Template.chatPanel.events
  'click a[data-action=close]': (e, tpl) ->
    tpl.$('.desk-chat-panel').removeClass('is-open')

  'keyup input[name=chat]': (e, tpl) ->
    if e.keyCode is 13
      tpl.$('button[data-action=send]').click()

  'click button[data-action=send]': (e, tpl) ->
    EventStream.insert
      projectId: Session.get('current_project')
      userId: Meteor.userId()
      type: 'chat'
      message: tpl.$('input[name=chat]').val()

    tpl.$('input[name=chat]').val('')

Template.chatPanel.helpers
  events: -> EventStream.find {}, { sort: { timestamp: -1 } }
  fullName: -> User.first(@userId)?.fullName()
