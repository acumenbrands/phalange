Phalange = {}

Phalange.EventBus = $.extend {}, Backbone.Events

class Phalange.Form extends Backbone.View
  initialize: ->
    @el.action = 'javascript:void(0)'
    Phalange.EventBus.on 'appended', @display

  events:
    "focusout": "hide"
    "submit": "hide"

  tagName: 'form'
  className: 'phalange-form'

  hide: => @$el.hide()
  display: => @$el.css display: 'block'

class Phalange.Input extends Backbone.View
  initialize: ({@text, @$container, @$form}) ->
    @$el.val @text
    Phalange.EventBus.on "appended", @focus

  className: 'phalange-input'
  tagName: 'input'

  focus: => @$el.focus()
  val: -> @$el.val()

class Phalange.Container extends Backbone.View
  initialize: ->
    @text = @$el.text()
    @formBuilder()

  events:
    "click": "append"
    "focusout": "submit"

  submit: (e) ->
    @setText()
    userInput = @formBuilder().input()

    if @text isnt userInput
      @text = userInput
      @$el.trigger 'phalange:submit', @text

  setText: ->
    @$el.text @formBuilder().input()

  append: ->
    @$el.text ''
    @$el.append @$form()
    # @$form().css display: 'block'
    # @$form().find('input').focus()
    Phalange.EventBus.trigger "appended"

  formBuilder: ->
    @__builder ?= new Phalange.FormBuilder @text, @$el

  $form: ->
    @formBuilder().$el()

class Phalange.FormBuilder
  constructor: (@text, @container) ->
    @_form().$el.append @_input().$el

  input: ->
    @_input().val()

  $el: ->
    @_form().$el

  _form: ->
    @__form ?= new Phalange.Form()

  _input: ->
    @__input ?= new Phalange.Input
      text: @text
      $container: @$container
      $form: @_form().$el

if module?
  module.exports = Phalange
else
  window.Phalange = Phalange

jQuery.fn.edit = $.fn.edit = ->
  form = new Phalange.Container( el: @ )
  @
