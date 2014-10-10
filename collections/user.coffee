class @User extends Minimongoid

  @_collection: Meteor.users

  @current: ->
    if Meteor.userId()
      User.init Meteor.user()

  @search: (token) ->
    console.log('search', token)
    Meteor.users.find({
      $or: [
          {"profile.firstName": {$regex: ".*#{token}.*", $options: 'i'}},
          {"profile.lastName": {$regex: ".*#{token}.*", $options: 'i'}}
          {"emails.address": {$regex: ".*#{token}.*", $options: 'i'}}
      ]
    })

  primaryEmail: () ->
    if @emails && @emails[0]
      #if user has multiple, which is primary?
      @emails[0].address

  fullName: () ->
    "#{@profile.firstName} #{@profile.lastName}"
