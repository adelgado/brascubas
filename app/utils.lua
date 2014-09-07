return {
	guesscontenttype = function (filename)
		extensions = {
			['css']  = 'text/css'        ,
			['js']   = 'text/javascript' ,
			['html'] = 'text/html'       ,
		}

		extension = filename:match('\.(%a+)$')

		return extensions[extension] or 'text/plain'
	end,

	logerror = function (error)
		print('Error: ' .. tostring(error))
	end
}
