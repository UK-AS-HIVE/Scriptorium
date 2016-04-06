Meteor.methods
  requestAccount: (user) ->
    console.log "New user requested account: "
    console.log user
    id = RequestedAccounts.insert user

    if not Meteor.users.findOne()? or user.email in Meteor.settings.approverEmails
      # First user or emails who are selected as approvers are automatically approved.
      Meteor.call 'approveAccount', id
    else
      Email.send
        from: Meteor.settings.email.fromEmail
        to: user.email
        subject: "Your Scriptorium account request has been received."
        html: "Your request for a Scriptorium account has been recorded. You should receive a response within 48 hours. Thank you for your interest in using Scriptorium."
      Email.send
        from: Meteor.settings.email.fromEmail
        to: Meteor.settings.approverEmails
        subject: "New Scriptorium Account Request"
        html: "A new account request has been received. Review account requests at https://#{Meteor.absoluteUrl()}pendingAccounts"

  approveAccount: (id) ->
    console.log "Account for #{RequestedAccounts.findOne(id).email} approved by #{@userId}"
    RequestedAccounts.update id, { $set: { approved: true} }
    Email.send
      from: Meteor.settings.email.fromEmail
      to: RequestedAccounts.findOne(id).email
      subject: "Your Scriptorium account request has been approved."
      html: "Your request for a Scriptorium account has been approved. Please visit this link to complete your registration:<br><br>
        <a href='#{Meteor.absoluteUrl()}signup/#{id}'>Register for Scriptorium</a>"

  denyAccount: (id) ->
    console.log "Account for #{RequestedAccounts.findOne(id).email} denied by #{@userId}"
    RequestedAccounts.update id, { $set: { denied: true } }
    Email.send
      from: Meteor.settings.email.fromEmail
      to: RequestedAccounts.findOne(id).email
      subject: "Your Scriptorium account request has been denied."
      html: "Your request for a Scriptorium account has been denied. Thank you for your interest in Scriptorium."
