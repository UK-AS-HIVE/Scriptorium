Meteor.methods({
	saveAnnotoriusAnnos: function(src, x, y, width, height, text, scptId){
		console.log(src + " " + text + " " + scptId);

    projectArray = scptId.split("|");

    // Annotations.insert({"canvas": src, "x": x, "y": y, "w": width, "h": height, "text": text, "manifest": projectArray[0], "project": projectArray[1]});

    Annotations.upsert({"canvas": src, "manifest": projectArray[0], "project": projectArray[1]}, {$push: {"annotations": {"x": x, "y": y, "w": width, "h": height, "text": text}}})

	}

})