Template.chatPanel.events
  'click a[data-action=close]': (e, tpl) ->
    tpl.$('.desk-chat-panel').removeClass('is-open')

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

Template.chatPanel.helpers
  events: -> EventStream.find {}, { sort: { timestamp: 1 } }
  fullName: -> User.first(@userId)?.fullName()

Template.chatPanel.onRendered ->
  tpl = @
  EventStream.find().observe
    added: ->
      if tpl.$('.chat-area')[0]?.scrollHeight - tpl.$('.chat-area').scrollTop() < $(window).height() or
      $('.chat-area').scrollTop() is 0 and not tpl.$('.desk-chat-panel').hasClass('is-open')
        tpl.$('.chat-area').scrollTop tpl.$('.chat-area')[0].scrollHeight
