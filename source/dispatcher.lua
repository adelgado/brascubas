local fs = require'luanode.fs'

routes = {}

routes['/'] = function (req, res)
	fs.readFile('views/index.html', function(error, data)
		if not error then
			res:writeHead(200, {["Content-Type"] = "text/html"})
			res:finish(data)
		end
	end)
end

routes['/room'] = function (req, res)
	res:writeHead(200, {["Content-Type"] = "text/plain"})
	res:finish('/room')
end

routes[404] = function (req, res)
	fs.readFile('views/404.html', function(error, data)
		if error then
			routes[500](req, res, data)
		else
			res:writeHead(404, {["Content-Type"] = "text/html"})
			res:finish(data)
		end
	end)
end

routes[500] = function (req, res, data)
	res:writeHead(500, {["Content-Type"] = "text/html"})
	res:finish(data)
end

routes['static'] = function (req, res)
	filename = req.url:sub(2)

	if filename:match('[%a%d/\._\-]+') then
		fs.readFile(filename, function (error, data)
			if error then
				return routes[404](req, res, data)
			else
				print('Serving static file', filename)
				res:writeHead(200, {["Content-Type"] = "text/plain"})
				return res:finish(data)
			end
		end)
	else
		routes[404](req, res, data)
	end
end

return function (self, req, res)
	if type(routes[req.url]) == 'function' then
		routes[req.url](req, res)
		print('Dispatching to controller for route ', req.url)
	elseif req.url:match('^/public') then
		routes['static'](req, res)
	else
		routes[404](req, res)
	end
end
