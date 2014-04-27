local fs = require'luanode.fs'

return function (req, res)
	fs.readFile('../views/404.html', function(error, data)
		if error then
			routes[500](req, res, data)
		else
			print('File not found', req.url)
			res:writeHead(404, {["Content-Type"] = "text/html"})
			res:finish(data)
		end
	end)
end
