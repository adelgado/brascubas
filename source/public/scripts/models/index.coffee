define [
  'chaplin',
  'models/base/model'
], (
	Chaplin
	Model
) ->
  'use strict'

  class Index extends Model
    defaults:
      message: 'Index!'

    # initialize: (attributes, options) ->
    #   super
    #   console.debug 'HelloWorld#initialize'
