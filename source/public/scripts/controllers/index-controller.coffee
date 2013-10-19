define [
  'controllers/base/controller'
  'models/index'
  'views/index-view'
], (
  Controller
  Index
  IndexView
) ->
  'use strict'

  class IndexController extends Controller
    show: (params) ->
      @model = new Index()
      @view = new IndexView
        model: @model
        region: 'main'
