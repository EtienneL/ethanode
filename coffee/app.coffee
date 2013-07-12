express = require 'express'
q = require 'q'
fs = require 'fs'

app = express()

# On a request to /, echo back what can be done


# Deferred file read function
loadski = (filepath) ->
	deferred = q.defer()
	fs.readFile filepath, 'utf-8', (error,text) ->
		if error
			deferred.reject(new Error(error))
		else
			deferred.resolve text

	return deferred.promise

images = {}

# Load the JSON into memory, to index into later
loadski('json/photos.json').then (data) ->
	images = JSON.parse(data).images

# Handle request for methods
app.get '/', (req,res) ->
	loadski('methods.html').then (data) ->
		res.end data

# On a request to /backend/rest/albums/photos, load the json
app.get '/backend/rest/albums/photos', (req,res) ->
	loadski('json/photos.json').then (data) ->
		res.end data

# On a request to /backend/rest/image/retrieveid/imageid, return the image
app.get '/backend/rest/image/retreiveid/:imgid', (req,res) ->
	url = images[req.params.imgid].src
	filename = url.substr(url.lastIndexOf('/')+1)
	res.sendfile 'photos/'+filename


port = process.env.PORT || 5000

console.log 'listening on ' + port

app.listen port

