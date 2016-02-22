Template.mirador.rendered = ->

  # thisObject = {"id": "viewer", "data": []}

  # myMani = AvailableManifests.find().fetch()
  # root = Meteor.absoluteUrl()

  # for item in myMani
  #   maniUri = root + "manifest/" + item["_id"] + "/" + Session.get("current_project")
  #   workspaces = Workspaces.find({"manifestUri": maniUri, "project": Session.get("current_project"), "user": Meteor.userId()}).fetch()
  #   if workspaces.length > 0
  #     widgets = workspaces[0].widgets
  #   else
  #     widgets = []
  #   thisObject["data"].push({"manifestUri": maniUri, "location": item["manifestLocation"], "title": item["manifestTitle"], "widgets": widgets})

  # # Meteor.setTimeout ( ->
		# # Mirador thisObject
  # # ), 1000
  # Mirador thisObject

  #Meteor.miradorFunctions.loadMirador()
  return

@ActiveWidgets = new Mongo.Collection null
@miradorFunctions = @miradorFunctions || {}
@miradorFunctions = _.extend @miradorFunctions, {
  getJsonFromUrl: (url, async) ->
    json = null
    jQuery.ajax
      url: url
      dataType: 'json'
      async: async || false
      success: (data) ->
        json = data
      error: (xhr, status, error) ->
        console.error xhr, status, error

    return json

  genUUID: ->
    idNum = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random() * 16|0
      v = if c == 'x' then r else r & 0x3 | 0x8
      return v.toString(16)

    return "uuid-" + idNum
}
