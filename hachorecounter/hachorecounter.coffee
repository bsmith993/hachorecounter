class Dashing.Hachorecounter extends Dashing.ClickableWidget
  constructor: ->
    super
    @queryState()

  @accessor 'value',
    get: -> if @_value then (if isNaN(Math.round(@_value)) then @_value else Math.round(@_value) ) else "??"
    set: (key, value) -> @_value = value

  queryState: ->
    $.get '/homeassistant/sensor',
      widgetId: @get('id'),
      deviceId: @get('device')
      (data) =>
        json = JSON.parse data
        @set 'value', json.value


  @accessor 'value-style', ->
    if @get('value') >=3 then 'status-good'
    else
      if @get('value') >=1 then 'status-warn'
      else 'status-bad'


  toggleState: ->
    newState = 'on'
    @set 'state', newState
    return newState

  postState: ->
    newState = 'on'
    $.post '/homeassistant/switch',
      widgetId: @get('id'),
      command: newState,
      (data) =>
        json = JSON.parse data

  levelDown: ->
    newState = 'off'
    $.post '/homeassistant/switch',
      widgetId: @get('id'),
      command: newState,
      (data) =>
        json = JSON.parse data



  ready: ->
    if @get('bgcolor')
      $(@node).css("background-color", @get('bgcolor'))

  onData: (data) ->




  onClick: (event) ->
    if event.target.id == "level-down"
      @levelDown()
    else if event.target.id == "switch"
      @postState()
