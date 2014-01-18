return function (req, res, data)
	print('Internal server error', data)
	res:writeHead(500, {["Content-Type"] = "text/html"})
	res:finish(data)
end
