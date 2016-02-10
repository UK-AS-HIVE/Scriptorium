Meteor.startup ->
  Accounts.config
    forbidClientAccountCreation: true

  Accounts.ui.config
    passwordSignupFields: 'EMAIL_ONLY'

  AccountsEntry.config
    homeRoute: '/'
    dashboardRoute: '/desk'
    language: 'en'
    showSignupCode: false
