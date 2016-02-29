Meteor.startup ->
  AccountsEntry.config
    homeRoute: '/'
    dashboardRoute: '/desk'
    language: 'en'
    showSignupCode: false

Tracker.autorun ->
  if Session.get('current_project')
    Meteor.users.update Meteor.userId(), { $set: { lastProjectId: Session.get('current_project') } }
  else
    Session.set 'current_project', Meteor.user().lastProjectId || Projects.findOne()?._id || "Free Space"
