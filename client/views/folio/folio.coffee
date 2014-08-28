Template.folio.helpers
	items:->
		folioItems.find()
	isPublished: (published)->
		this.published == published
