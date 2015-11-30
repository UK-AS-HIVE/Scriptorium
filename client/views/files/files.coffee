Session.setDefault "searchVal", ""
searchTracker = Tracker.autorun( ->
  Meteor.subscribe "filecabinetsearch", Session.get "searchVal"
)

Template.files.helpers
  areFiles: ->
    projectFiles = FileCabinet.find({'project': Session.get('current_project')}).fetch()
    if projectFiles.length != 0
      true
    else
      false

  docAuthor: ->
    author = Meteor.users.findOne({_id: this.user}).profile
    author.firstName + " " + author.lastName

  files: ->
    FileCabinet.find({'project': Session.get('current_project')})

  isEditorFile: ->
    if this.fileType == "editor"
      true
    else
      false

  getFileName: ->
    file = FileRegistry.findOne("_id": this.content)
    file.filenameOnDisk

  otherProject: ->
    projects = Projects.find({_id: {$ne: Session.get('current_project')}}).fetch()
    projects.push({projectName: "Free Space"})
    return projects
Template.files.events

  "click .btn-filecab-search": (e, tmpl) ->
    Session.set "searchVal", tmpl.find(".search-value").value

  "click .delete": ->
    Session.set "fc_file_to_del", this._id
    $("#confirmDelete").modal('show')

  "click #deleteOk": ->
    Meteor.call("deleteEditorDoc", Session.get "fc_file_to_del")
    Session.set "fc_file_to_del", ""
    $("#confirmDelete").modal('hide')

  "click #deleteCancel": ->
    $("#confirmDelete").modal('hide')

  "click .fileUpload": (e, tmpl) ->
    Media.pickLocalFile (fileId) ->
      fileButton = tmpl.find(".fileUpload")
      saveButton = tmpl.find(".save-file-btn")
      fileName = FileRegistry.findOne({"_id": fileId})
      $(fileButton).text(fileName.filename)
      Session.set "file_cab_upload_id", fileId
      $(saveButton).removeClass("disabled")

  "click .save-file-btn": (e, tmpl) ->
    desc = tmpl.find('textarea#fileDesc')
    console.log $(desc).val()
    Meteor.call 'saveFileToProject', Session.get('file_cab_upload_id'), Meteor.userId(), Session.get('current_project'), $(desc).val()

  "click .move": (e, tmpl)->
    Session.set("fc_file_to_move", this._id)
    $("#moveModal").modal('show')

  "click #moveOk": (e, tmpl)->
    id = Session.get("fc_file_to_move")
    newProject = tmpl.find(".new-project").value
    copy = FileCabinet.findOne(id, {fields : {_id:0}})
    copy.project = newProject
    FileCabinet.insert(copy)
    $("#moveModal").modal('hide')

  "click .delete-batch-btn": ->
    $("#confirmBatchDelete").modal('show')

  "click #deleteBatchOk": (e, tmpl)->
    selected = tmpl.findAll(".batch-checkbox:checked")
    for i in selected
      Meteor.call("deleteEditorDoc", Blaze.getData(i)._id)
    $("#confirmBatchDelete").modal('hide')

  # "click .open-batch-btn": (e, tmpl)->
  #   selected = tmpl.findAll(".batch-checkbox:checked")
  #   console.log(selected)
  #   for i in selected
  #     path = "/file/"+ FileRegistry.findOne("_id": Blaze.getData(i).content).filenameOnDisk
  #     window.open(path)

  "click .move-batch-btn": (e, tmpl)->
    $("#moveBatchModal").modal('show')

  "click .submit-batch-move": (e, tmpl)->
    selected = tmpl.findAll(".batch-checkbox:checked")
    newProject = tmpl.find(".new-project-batch").value
    for i in selected
      id = Blaze.getData(i)._id
      copy = FileCabinet.findOne(id, {fields : {_id:0}})
      copy.project = newProject
      FileCabinet.insert(copy)
    $("#moveBatchModal").modal('hide')

  "click .selectAll": (e, tmpl)->
    all = tmpl.findAll(".batch-checkbox")
    for i in all
      i.checked = e.target.checked
