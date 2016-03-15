tickDeps = new Tracker.Dependency()

Meteor.setInterval ->
  tickDeps.changed()
, 1000

fromNowReactive = (date) ->
  tickDeps.depend()
  return moment(date).fromNow()

Template.timeFromNow.helpers
  parsedTime: -> fromNowReactive @
