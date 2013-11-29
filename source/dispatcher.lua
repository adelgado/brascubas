local fs = require'luanode.fs'

controllers = {}

controllers['/'] = function (request, response)
	fs.readFile('views/index.html', function(error, data)
		if not error then
			response:writeHead(200, {["Content-Type"] = "text/html"})
			response:finish(data)
		end
	end)
end

controllers['/room'] = function (request, response)
	response:writeHead(200, {["Content-Type"] = "text/plain"})
	response:finish('/room')
end

return function(self, request, response)
	if type(controllers[request.url]) == 'function' then
		controllers[request.url](request, response)
		print('Dispatching to controller for route ', request.url)
	else
		response:writeHead(404)
		response:finish()
	end

	-- print'self'
	-- for k, v in pairs(self) do
	-- 	print(k, v)
	-- end

	-- print'request'
	-- for k, v in pairs(request) do
	-- 	print(k, v)
	-- end

	-- print'response'
	-- for k, v in pairs(response) do
	-- 	print(k, v)
	-- end

end
