Accounts.onCreateUser (options, user) ->
  if not RequestedAccounts.findOne { email: user.emails[0].address, approved: true}
    throw new Meteor.Error 'This email address has not been approved for signup.'
  else
    RequestedAccounts.update { email: user.emails[0].address }, { $set: { created: true } }
    if options.profile
      user.profile = options.profile
    return user

