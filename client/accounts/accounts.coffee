Meteor.startup ->
  AccountsEntry.config
    homeRoute: '/'
    dashboardRoute: '/desk'
    language: 'en'
    showSignupCode: false
