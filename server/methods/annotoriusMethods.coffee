Meteor.methods
  saveAnnotoriusAnnos: (src, x, y, width, height, text, scptId) ->
    projectArray = scptId.split("|")
    Annotations.upsert { "canvas": src, "manifest": projectArray[0], "project": projectArray[1] },
      { $push: { "annotations": {"x": x, "y": y, "w": width, "h": height, "text": text } } }

  deleteAnnotoriusAnnos: (src, x, y, width, height, text, scptId) ->
    projectArray = scptId.split("|")

    Annotations.update({"canvas": src, "manifest": projectArray[0], "project": projectArray[1]}, {$pull: {"annotations": {"x": x, "y": y, "w": width, "h": height, "text": text}}})

