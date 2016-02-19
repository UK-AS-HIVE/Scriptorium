Template.files.onCreated ->
  @searchVal = new ReactiveVar ""
Template.files.onRendered ->
  @autorun =>
    Meteor.subscribe 'filecabinetsearch', @searchVal.get()

Template.files.helpers
  docAuthor: ->
    author = Meteor.users.findOne({_id: @user}).profile
    author.firstName + " " + author.lastName

  files: ->
    FileCabinet.find({'project': Session.get('current_project')})

  isEditorFile: ->
    @fileType is "editor"

  getFileName: ->
    FileRegistry.findOne(@content)?.filenameOnDisk

  otherProject: ->
    projects = Projects.find({_id: {$ne: Session.get('current_project')}}).fetch()
    projects.push({projectName: "Free Space"})
    return projects

Template.files.events
  'click [data-toggle=batchModal]': (e, tpl) ->
    modal = tpl.$(e.currentTarget).data('modal')
    data = _.map tpl.findAll(".batch-checkbox:checked"), (i) -> Blaze.getData(i)
    Blaze.renderWithData Template[modal], data, $('body').get(0)
    $("##{modal}").modal('show')

  'click [data-toggle=modal]': (e, tpl) ->
    modal = tpl.$(e.currentTarget).data('modal')
    Blaze.renderWithData Template[modal], @, $('body').get(0)
    $("##{modal}").modal('show')

  'input input[name=search]': _.debounce (e, tpl) ->
    tpl.searchVal.set tpl.$("input[name=search]").val()

  'click button[data-action=search]': (e, tpl) ->
    tpl.searchVal.set tpl.$("input[name=search]").val()

  'click button[data-action=selectAll]': (e, tpl)->
    tpl.$('.batch-checkbox').prop('checked', e.target.checked)
