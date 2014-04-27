return function (req, res)
	fs.readFile('../views/index.html', function(error, data)
		if not error then
			res:writeHead(200, {["Content-Type"] = "text/html"})
			res:finish(data)
		end
	end)
end
