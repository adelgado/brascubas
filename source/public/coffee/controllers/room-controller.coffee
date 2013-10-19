define [
  'controllers/base/controller'
  # 'models/index'
  'views/room-view'
], (
  Controller
  # Index
  RoomView
) ->
  'use strict'

  class RoomController extends Controller
    
    show: (params) ->
      # @model = new Index()
      @view = new RoomView
        # model: @model
        region: 'main'
