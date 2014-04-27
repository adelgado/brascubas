local fs = require'luanode.fs'

local function guesscontenttype(filename)
	extensions = {
		['css']  = 'text/css'        ,
		['js']   = 'text/javascript' ,
		['html'] = 'text/html'       ,
	}

	extension = filename:match('\.(%a+)$')

	return extensions[extension] or 'text/plain'
end

local function logerror(error)
	print('Error: ' .. tostring(error))
end

routes = {}

-- Index route
routes['/'] = function (req, res)
	fs.readFile('views/index.html', function(error, data)
		if error then
			logerror(error)
			routes[404](req, res)
		else
			res:writeHead(200, {["Content-Type"] = "text/html"})
			res:finish(data)
		end
	end)
end

-- Not found
routes[404] = function (req, res)
	fs.readFile('views/404.html', function(error, data)
		if error then
			logerror(error)
			routes[500](req, res, data)
		else
			res:writeHead(404, {["Content-Type"] = "text/html"})
			res:finish(data)
		end
	end)
end

-- Server error
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
				logerror(error)
				return routes[404](req, res, data)
			else
				print('Serving static file', filename)
				contenttype = guesscontenttype(filename)
				res:writeHead(200, {
					["Content-Type"] = contenttype
				})
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
