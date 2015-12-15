Meteor.publish "getFolioRecords", () ->
  console.log "records"
  folioItems.find({published: true}, {fields: {canvas: 0}})