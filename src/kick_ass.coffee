#
# Project's main unit
#
# Copyright (C) 2012 Nikolay Nemshilov
#
class KickAss extends Element
  extend:
    Options:
      size:   800  # the amount of dom elements to be created
      tests:  null # test names in an array or `null` to run everything
      native: true # show raw DOM test

    Tests:
      make:          "Elements building"
      findById:      "Access an element by ID"
      findByCSS:     "Access by a CSS rule"
      bind:          "Add an event listener"
      unbind:        "Remove an event listener"
      set:           "Set an element attribute"
      get:           "Get an element attribute"
      style:         "Assign an element style"
      addClass:      "Add css-class"
      removeClass:   "Remove css-class"
      update:        "Set new html content"
      insertBottom:  "Insert element bottom"
      insertTop:     "Insert element on top"
      insertAfter:   "Insert element after"
      insertBefore:  "Insert element before"
      remove:        "Remove element"

    Libs:
      ['lovely', 'rightjs', 'jquery', 'mootools', 'dojo', 'yui']

  #
  # Basic constructor, builds the UI
  #
  # @param {Object} options
  # @return {KickAss} this
  #
  constructor: (options)->
    options = @setOptions(options)
    super 'div', class: 'kick-ass'

    @frames = new Frames(@)
    @table  = new Table(@)
    @stats  = new Stats(@)

    @on 'result', (event)->
      @stats.record(event.lib, event.test, event.time)

    @on 'finish', ->
      @table.display(@stats)

    return @

  #
  # Sets the options
  #
  # @param {Object} options
  # @return {Object} cleaned options
  #
  setOptions: ->
    options = UI.Options.setOptions.apply(@, arguments)

    @tests  = options.tests || core.Hash.keys(KickAss.Tests)
    delete(options.tests)

    @libs = if @options.native then ['Raw DOM'] else []

    for key in @constructor.Libs
      if key of options
        @libs.push(key + "-" + options[key])
        delete(options[key])

    return options

  #
  # Starts the test running
  #
  # @return {KickAss} this
  #
  start: ->
    @frames.run(@tests)

    @emit 'finish'
