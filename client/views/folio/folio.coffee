Template.folio.helpers
	items:->
		folioItems.find()
	isPublished: (published)->
		this.published == published

Template.folio.events
	"click .folio-edit-btn": ->
		Session.set "editFolioItem", this["_id"]
		Router.go "folioEdit"