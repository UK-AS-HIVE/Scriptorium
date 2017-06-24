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

@ImageMetadata = new Meteor.Collection('iiifImageMetadata')
@ImageMetadata.attachSchema new SimpleSchema
  manifestId:
    type: String
  retrievalUrl:
    type: String
    regEx: SimpleSchema.RegEx.Url
  retrievalTimestamp:
    type: new Date()
  payload:
    type: Object
    blackbox: true

@DeskWidgets = new Mongo.Collection 'deskWidgets'

@DeskSnapshots = new Mongo.Collection 'deskSnapshots'
@DeskSnapshots.attachSchema new SimpleSchema
  projectId:
    type: String
  userId:
    type: String
  title:
    type: String
  description:
    type: String
    optional: true
  timestamp:
    type: new Date()
  widgets:
    type: [Object]
    blackbox: true

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
  type:
    type: String
    allowedValues: ['commentary', 'transcription']
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
  editorLockedByUserId:
    label: "Editor Locked By User ID"
    type: String
    optional: true
  editorLockedByConnectionId:
    label: "Editor Locked By Connection ID"
    type: String
    optional: true

# class @folioItems extends Minimongoid
# 	 @_collection: new Meteor.Collection('folioitems')
@folioItems = new Meteor.Collection('folioitems')
@folioItems.attachSchema new SimpleSchema
  projectId:
    type: String
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
    blackbox: true
  'metadata.city':
    type: String
  'metadata.repository':
    type: String
  'metadata.collectionNumber':
    type: String
  'metadata.dateRange':
    type: [Number]
  'metadata.typeOfDocument':
    label: 'Type of Document'
    type: [String]
    allowedValues: ['All', 'Teaching Text', 'Administrative Document', 'Pastoral Care', 'Used in Dispute, Litigation, or Judgment', 'Legal Theory', 'Instrument of Government', 'For Private Use', 'Other']
  'metadata.communityContext':
    label: 'Community Context'
    type: String
    allowedValues: ['All', 'School or University', 'Manor or Village', 'Monastery', 'Cathedral and Episcopal Court', 'Royal or Imperial Court', 'Papal Curia', 'Town', 'Other']
    optional: true
  'metadata.scriptRegion':
    label: 'Region'
    type: String
  'metadata.scriptAlphabet':
    type: String
  'metadata.traditionalClassification':
    type: String
    optional: true
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
    optional: true
  'metadata.collection':
    type: String
    optional: true
  'metadata.commonName':
    type: String
    optional: false
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
  'metadata.associatedWithPerson':
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
  annotations:
    type: [Object]
    optional: true
  'annotations.$.type':
    type: String
    allowedValues: ['commentary', 'transcription']
  'annotations.$.text':
    type: String
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

@EventStream = new Meteor.Collection 'eventStream'
@EventStream.attachSchema new SimpleSchema
  projectId:
    label: "Project Id"
    type: String
  userId:
    label: "User ID"
    type: String
  timestamp:
    label: "Timestamp"
    type: new Date()
    autoValue: -> new Date()
  type:
    # TODO: Figure out what these are actually going to be
    # Potential information to want to store: chat messages, document creation, save revision, user added to project, manifest added?
    allowedValues: [ 'deskSnapshots', 'filecabinet', 'annotations', 'availablemanifests', 'chat', 'project' ]
    type: String
    label: "Event Type"
  message:
    type: String
    label: "Message"
    optional: true
  otherId:
    # FileCabinet ID, Bookshelf ID, Manifest ID, etc.
    type: String
    label: "Other ID"
    optional: true

@Messages = new Mongo.Collection 'messages'
@Messages.attachSchema new SimpleSchema
  subject:
    label: "Subject"
    type: String
  roomId:
    label: "Room/Project Id"
    type: String
  startedBy:
    label: "Thread Started By"
    type: String
  timestamp:
    type: new Date()
  posts:
    label: "Posts"
    type: [ Object ]
    optional: true
  'posts.$.user':
    label: "Post Author"
    type: String
  'posts.$.message':
    label: "Post"
    type: String
  'posts.$.timestamp':
    label: "Post Timestamp"
    type: new Date()

@RequestedAccounts = new Mongo.Collection 'requestedAccounts'
@RequestedAccounts.attachSchema new SimpleSchema
  email:
    unique: true
    label: "Email"
    type: String
  firstName:
    label: "First Name"
    type: String
  lastName:
    label: "Last Name"
    type: String
  institution:
    label: "Institutional Affiliation"
    type: String
    optional: true
  research:
    label: "Area of Research"
    type: String
  newProjectRequest:
    label: "New Project Request Information"
    type: String
    optional: true
  existingProjectRequest:
    label: "Existing Project Request Information"
    type: String
    optional: true
  denied:
    type: Boolean
    defaultValue: false
  approved:
    type: Boolean
    defaultValue: false
  created:
    type: Boolean
    defaultValue: false
