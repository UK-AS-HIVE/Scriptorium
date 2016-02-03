Meteor.publish "getFolioRecords", ->
  folioItems.find { published: true }, { fields: { canvas: 0 } }
