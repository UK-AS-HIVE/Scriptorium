Template.welcome.helpers
  isntPersonalProject: ->
    Projects.findOne(Session.get('current_project'))?.personal isnt Meteor.userId()
  fullName: ->
    "#{Meteor.user().profile.lastName}, #{Meteor.user().profile.firstName}"
