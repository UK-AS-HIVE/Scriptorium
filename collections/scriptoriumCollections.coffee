@AvailableManifests = new Meteor.Collection('availablemanifests')
@AvailableManifests.attachSchema new SimpleSchema
  user:
    label: "User"
    type: String
  project:
    label: "Project ID"
    type: String
  manifestPayload:
    label: "Manifest Payload"
    type: Object
    blackbox: true
  manifestLocation:
    label: "Manifest Location"
    type: String
  manifestTitle:
    label: "Manifest Title"
    type: String

@Projects = new Meteor.Collection('projects')
@Projects.attachSchema new SimpleSchema
  projectName:
    label: "Project Name"
    type: String
  personal:
    label: "Personal ID"
    type: String
    optional: true
  permissions:
    label: "Permissions"
    type: [ Object ]
  'permissions.$.level':
    label: "Permissions Level"
    type: String
    allowedValues: [ 'admin', 'contributor' ]
  'permissions.$.user':
    label: "Permissions User"
    type: String
  miradorData:
    label: "Mirador Data"
    type: [ Object ]
  'miradorData.$.manifestUri':
    label: "Manifest URI"
    type: String
  'miradorData.$.location':
    label: "Manifest Location"
    type: String
  'miradorData.$.title':
    label: "Manifest Title"
    type: String
  'miradorData.$.widgets':
    label: "Mirador Widgets"
    type: [Object]

@Annotations = new Meteor.Collection('annotations')
@Annotations.attachSchema new SimpleSchema
  canvasIndex:
    label: "Annotation Canvas"
    type: Number
  manifestId:
    label: "Project Manifest"
    type: String
  projectId:
    label: "Project"
    type: String
  text:
    type: String
  x:
    type: Number
    decimal: true
  y:
    type: Number
    decimal: true
  w:
    type: Number
    decimal: true
  h:
    type: Number
    decimal: true

@Workspaces = new Meteor.Collection('workspaces')
@Workspaces.attachSchema new SimpleSchema
  user:
    label: "User"
    type: String
  project:
    label: "Project"
    type: String
  manifestUri:
    label: "Manifest URI"
    type: String
  widgets:
    label: "Workspace Widgets"
    type: [ Object ]
  'widgets.$.height':
    type: Number
    decimal: true
  'widgets.$.type':
    type: String
  'widgets.$.width':
    type: Number
    decimal: true
  'widgets.$.position':
    type: Object
  'widgets.$.position.at':
    type: String
  'widgets.$.position.collision':
    type: String
  'widgets.$.position.my':
    type: String
  'widgets.$.position.of':
    type: String
  'widgets.$.position.within':
    type: String

@FileCabinet = new Meteor.Collection('filecabinet')
@FileCabinet.attachSchema new SimpleSchema
  # TODO: this stores either text from CKEditor, or a FileRegistry ID reference
  # probably should split into separate fields
  content:
    label: "Content"
    type: String
    optional: true
  fileRegistryId:
    label: "File Registry ID"
    type: String
    optional: true
  date:
    label: "Date Uploaded"
    type: new Date()
  description:
    optional: true
    label: "Description"
    type: String
  fileType:
    label: "File Type"
    type: String
    allowedValues: [ "upload", "editor", "annotation" ]
  open:
    label: "File Open?"
    type: Boolean
  project:
    label: "Project ID"
    type: String
  title:
    label: "Title"
    type: String
  user:
    label: "User ID"
    type: String

# class @folioItems extends Minimongoid
# 	 @_collection: new Meteor.Collection('folioitems')
@folioItems = new Meteor.Collection('folioitems')
@folioItems.attachSchema new SimpleSchema
  addedBy: # user id
    type: String
  lastUpdatedBy: # user id
    type: String
  canvas:
    type: Object
    label: "IIIF fragment"
    optional: true
    blackbox: true
  imageURL:
    type: String
  metadata:
    type: Object
    optional: true
  'metadata.city':
    type: String
  'metadata.repository':
    type: String
  'metadata.collectionNumber':
    type: String
  'metadata.dateRange':
    type: [Number]
  'metadata.scriptName':
    type: String
  'metadata.scriptFamily':
    type: String
  'metadata.scriptLanguage':
    type: String
  'metadata.scriptAlphabet':
    type: String
  'metadata.scriptTradition':
    type: String
  'metadata.specificText':
    type: String
  'metadata.folioNumber':
    type: String
  'metadata.description':
    type: String
  'metadata.features':
    type: String
  'metadata.transcription':
    type: String
  'metadata.collection':
    type: String
    optional: true
  'metadata.commonName':
    type: String
    optional: true
  'metadata.origin':
    type: String
    optional: true
  'metadata.provenance':
    type: String
    optional: true
  'metadata.dateExpression':
    type: String
    optional: true
  'metadata.author':
    type: String
    optional: true
  'metadata.title':
    type: String
    optional: true
  'metadata.contributors':
    type: String
    optional: true
  'metadata.manuscriptLink':
    type: String
    optional: true
  'metadata.info':
    type: String
    optional: true
  dateAdded:
    type: new Date()
    defaultValue: -> new Date()
  lastUpdated:
    type: new Date()
  published:
    type: Boolean
  manifest:
    type: String
    label: "Absolute URL to manifest json"

@Bookshelves = new Meteor.Collection('bookshelves')
@Bookshelves.attachSchema new SimpleSchema
  category:
    label: "Category"
    type: String
  project:
    label: "Project ID"
    type: String
  color:
    label: "Category Color"
    type: String
  rank:
    label: "Rank"
    type: Number
    decimal: true
@Books = new Meteor.Collection('books')
@Books.attachSchema new SimpleSchema
  name:
    label: "Book Name"
    type: String
  url:
    label: "Book URL"
    type: String
    optional: true
  bookshelfId:
    label: "Bookshelf ID"
    type: String
  rank:
    label: "Book Rank"
    type: Number
    decimal: true
  fileRegistryId:
    label: "File Registry ID"
    type: String
    optional: true
