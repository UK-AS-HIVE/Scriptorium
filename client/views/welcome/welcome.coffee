Template.welcome.helpers
  isntPersonalProject: ->
    Projects.findOne(Session.get('current_project'))?.personal isnt Meteor.userId()
  fullName: ->
    "#{Meteor.user()?.profile.lastName}, #{Meteor.user()?.profile.firstName}"

Template.welcome.events
  'click area[data-action=openHelp]': ->
    $('.help-panel').toggleClass('is-open')

  'click area': (e, tpl) ->
    if tpl.$(e.currentTarget).attr('href')
      e.preventDefault()
      Router.go tpl.$(e.currentTarget).attr('href')
