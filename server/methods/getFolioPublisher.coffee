Meteor.publish "get-folio-records", () ->
	folioItems.find({published: true}, {fields: {canvas: 0}})