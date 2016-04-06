Accounts.onCreateUser (options, user) ->
  RequestedAccounts.update { email: user.emails[0].address }, { $set: { created: true } }
  if options.profile
    user.profile = options.profile
  return user

