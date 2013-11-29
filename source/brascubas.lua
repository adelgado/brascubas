local http = require('luanode.http')

controllers = {}
controllers['/'] = function (request, response)
	response:writeHead(200, {["Content-Type"] = "text/plain"})
	response:finish('/')
end

controllers['/room'] = function (request, response)
	response:writeHead(200, {["Content-Type"] = "text/plain"})
	response:finish('/room')
end

http.createServer(function(self, request, response)
	if type(controllers[request.url]) == 'function' then
		controllers[request.url](request, response)
		print('Dispatching to controller for route ', request.url)
	else
	end

	print'self'
	for k, v in pairs(self) do
		print(k, v)
	end

	print'request'
	for k, v in pairs(request) do
		print(k, v)
	end

	print'response'
	for k, v in pairs(response) do
		print(k, v)
	end

end):listen(8124)

console.log('Server running at http://127.0.0.1:8124/')

process:loop()

-- app.use express.static path.join __dirname, 'public'
-- app.use express.static path.join __dirname, 'views'

-- app.all '/', (req, res) ->
--   res.sendfile 'views/index.html'

-- app.post '/room', (req, res) ->
-- 	id = Math.floor(Math.random() * 1000)

-- 	res.json(201, id: id)

-- app.get '/room/:id', (req, res) ->
-- 	res.send(200)

-- port = 80
-- app.listen port, ->
-- 	console.log "Listening on #{port}"
