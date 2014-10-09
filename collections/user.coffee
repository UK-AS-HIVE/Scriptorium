class @User extends Minimongoid

  @_collection: Meteor.users

  @current: ->
    if Meteor.userId()
      User.init Meteor.user()

  primaryEmail: () ->
    if @emails && @emails[0]
      #if user has multiple, which is primary?
      @emails[0].address

  fullName: () ->
    "#{@profile.firstName} #{@profile.lastName}"
