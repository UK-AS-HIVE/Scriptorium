Template.folio.helpers
  items:->
    folioItems.find()
  isPublished: (published)->
    this.published == published
  emailById: ->
    lastUpdate = Meteor.users.findOne({_id: this.lastUpdatedBy}).profile
    lastUpdate.firstName + " " + lastUpdate.lastName

Template.folio.events
  "click .folio-edit-btn": ->
    Session.set "editFolioItem", this["_id"]
    Router.go 'folioEdit'