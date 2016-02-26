class @User extends Minimongoid

  @_collection: Meteor.users

  @current: ->
    if Meteor.userId()
      User.init Meteor.user()

  @search: (token) ->
    search = { $regex: ".*#{token}.*", $options: 'i' }
    Meteor.users.find({
      $or: [
          {"profile.firstName": search},
          {"profile.lastName": search}
          {"emails.address": search}
      ]
    })

  primaryEmail:  ->
    if @emails && @emails[0]
      #if user has multiple, which is primary?
      @emails[0].address

  fullName: ->
    "#{@profile?.firstName} #{@profile?.lastName}"
