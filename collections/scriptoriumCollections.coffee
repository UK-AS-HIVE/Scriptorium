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
    # I don't know what this key is used for.
    label: "Personal ID"
    type: String
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
  'miradorData.$.title"':
    label: "Manifest Title"
    type: String
  'miradorData.$.widgets':
    label: "Mirador Widgets"
    type: [Object]

@Annotations = new Meteor.Collection('annotations')
@Annotations.attachSchema new SimpleSchema
  canvas:
    label: "Annotation Canvas"
    type: String
  manifest:
    label: "Project Manifest"
    type: String
  project:
    label: "Project"
    type: String
  annotations:
    label: "Annotations"
    type: [ Object ]
  'annotations.$.x':
    type: Number
    decimal: true
  'annotations.$.y':
    type: Number
    decimal: true
  'annotations.$.w':
    type: Number
    decimal: true
  'annotations.$.h':
    type: Number
    decimal: true
  'annotations.$.text':
    type: String

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
  content:
    label: "Content ID"
    type: String
  date:
    label: "Date Uploaded"
    type: new Date()
  description:
    label: "Description"
    type: String
  fileType:
    label: "File Type"
    type: String
    allowedValues: [ "upload", "editor" ]
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

@OpenDocs = new Meteor.Collection('opendocs')
@OpenDocs.attachSchema new SimpleSchema
  document:
    label: "Document ID"
    type: String
  project:
    label: "Project ID"
    type: String
  user:
    label: "User ID"
    type: String


# class @folioItems extends Minimongoid
# 	 @_collection: new Meteor.Collection('folioitems')
@folioItems = new Meteor.Collection('folioitems')
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
@Books = new Meteor.Collection('books')
@Books.attachSchema new SimpleSchema
  name:
    label: "Book Name"
    type: String
  url:
    label: "Book URL"
    type: String
  bookshelfId:
    label: "Bookshelf ID"
    type: String
  rank:
    label: "Book Rank"
    type: Number
