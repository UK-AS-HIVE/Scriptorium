Template.helpPanel.events
  "click .js-close-panel": ->
    $('.help-panel').removeClass('is-open')
  "click .show-content": ->
    Session.set("selectedHelpText", this.content)
    Session.set("selectedHelpTitle", this.title)
    $("#helpModal").modal("show")

Deps.autorun(->
  #if we hae access to current route
  currentRoute = ""
  if (Router.current())
    currentRoute = Router.current().route.name
  else
    return
  #request help file and parse it
  HTTP.get Meteor.absoluteUrl('/help/' + currentRoute + '.md'), (err, result) ->
    Session.set("helpContent", "")
    console.log("Requesting help files")
    if (!result.content)
      console.log("No help file for " + currentRoute)
      return
    console.log("Received help files for " + currentRoute)
    helpContent = result.content
    tempHelpContent = helpContent.split("\n")
    parsedHelpContent = []
    for i in tempHelpContent
      if (i[0] == "#" and i[1] != "#")
        parsedHelpContent.push({title: i.substr(1), content: []})
      else
        parsedHelpContent[parsedHelpContent.length-1].content = parsedHelpContent[parsedHelpContent.length-1].content + "\n" + i
    Session.set("helpContent", parsedHelpContent)
)

Template.helpPanel.helpers
  content: ->
    return Session.get("helpContent")
  helpText: ->
    return parseMarkdown(Session.get("selectedHelpText"))
  helpTitle: ->
    return Session.get("selectedHelpTitle")