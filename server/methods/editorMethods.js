Meteor.methods({
	saveEditorDoc: function(editorData){

		console.log(editorData);

	},

	getNewEditorID: function(){
		console.log("new editor instance requested");
		var newEditorID = FileCabinet.insert({
			'project': 000,
			'fileType': 'editor',
			'user': "andy",
			'date': new Date()
		});
		return newEditorID;
	}

})