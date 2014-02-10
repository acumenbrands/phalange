Phalange = {}

class Phalange.Form extends Backbone.View
  tagName: 'form'
  className: 'phalange-form'
  events:
    "focusout": "hide"
    "submit": "hide"

  hide: -> @$el.hide()

class Phalange.Input extends Backbone.View
  initialize: ({@text, @$container}) ->
    @$el.val @text
    @$container.on "click", @focus.bind @

  tagName: 'input'

  focus: -> @$el.focus()
  val: -> @$el.val()

class Phalange.Container extends Backbone.View
  initialize: ->
    @text = @$el.text()
    @formBuilder()

  events:
    "click": "append"
    "focusout": "submit"

  submit: ->
    @setText()
    userInput = @formBuilder().input()

    if @text isnt userInput
      @text = userInput
      @$el.trigger 'phalange:submit', @text

  setText: ->
    @$el.text @formBuilder().input()

  append: ->
    unless @formBuilder().isPresentIn @$el
      @$el.text ''
      @$el.append @$form()

  formBuilder: ->
    @__builder ?= new Phalange.FormBuilder @text, @$el

  $form: ->
    @formBuilder().$el()

class Phalange.FormBuilder
  constructor: (@text, @$container) ->
    @_form().$el.append @_input().$el

  input: ->
    @_input().val()

  $el: ->
    @_form().$el

  isPresentIn: ($el) ->
    _.include $el.children(), @_form().$el

  _form: ->
    @__form ?= new Phalange.Form()

  _input: ->
    @__input ?= new Phalange.Input text: @text, $container: @$container

if module?
  module.exports = Phalange
else
  window.Phalange = Phalange

$.fn.edit = ->
  form = new Phalange.Container( el: @ )
  @
