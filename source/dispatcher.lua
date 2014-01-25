local fs = require'luanode.fs'

routes = {}

routes['/'] = function (req, res)
	fs.readFile('views/index.html', function(error, data)
		print(data)
		if not error then
			res:writeHead(200, {["Content-Type"] = "text/html"})
			res:finish(data)
		else
			routes[404](req, res)
		end
	end)
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
			print(filename)
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
	print(req.method, req.url)

	if type(routes[req.url]) == 'function' then
		print('Dispatching controller action', req.url)
		routes[req.url](req, res, routes)
	elseif req.url:match('^/public') then
		print('Dispatching static file action', req.url)
		routes['static'](req, res)
	else
		print('Dispatching 404', req.url)
		routes[404](req, res)
	end
end


