local fs = require'luanode.fs'

return function (req, res, routes)
	fs.readFile(template, function(error, data)
		if not error then
			res:writeHead(200, {["Content-Type"] = "text/html"})
			res:finish(data)
		else
			routes[500](req, res, error)
		end
	end)
end
