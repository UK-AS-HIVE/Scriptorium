Template.pendingAccounts.helpers
  accounts: -> RequestedAccounts.find()
  fullName: (user) -> User.first(user)?.fullName()

Template.pendingAccounts.events
  'click button[data-action=approve]': ->
    Meteor.call 'approveAccount', @_id
  'click button[data-action=deny]': ->
    Meteor.call 'denyAccount', @_id
