Template.folio.helpers
	items:->
		folioItems.find()
	isPublished: (published)->
		this.published == published
	emailById: ->
		(Meteor.users.findOne({_id: this.lastUpdatedBy})).emails[0].address

Template.folio.events
	"click .folio-edit-btn": ->
		Session.set "editFolioItem", this["_id"]
		Router.go "folioEdit"