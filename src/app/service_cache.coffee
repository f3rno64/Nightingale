class ServiceCache

  ###
  # Instantiates and clears the cache
  #
  # @param [String] trackingKey key to track items by, usually 'id'
  ###
  constructor: (trackingKey) ->
    @_tracker = trackingKey
    @clear()

  ###
  # Reset the cache to a fresh state
  ###
  clear: ->
    @_data = {}
    @

  ###
  # Clears a single item from the cache
  #
  # @param [Object] key
  ###
  clearItem: (key) ->
    delete @_data[key]
    @

  ###
  # Sets an array of items in the cache
  #
  # @param [Array<Object>]
  ###
  setMultiple: (items) ->
    for item in items
      @_data[item[@_tracker]] = item if item[@_tracker]
    @

  ###
  # Sets a single item in the cache
  #
  # @param [Object] item
  ###
  setItem: (item) ->
    @_data[item[@_tracker]] = item if item[@_tracker]
    @

  ###
  # Checks if the specified tracking key is in the cache
  #
  # @param [Object] key
  # @return [Boolean] exists
  ###
  hasItem: (key) ->
    !!@_data[key]

  ###
  # Get a specific item by its' key
  #
  # @param [Object] key
  # @return [Object] item
  ###
  getItem: (key) ->
    @_data[key]
