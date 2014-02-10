$.fn.edit = ->
  form = new Phalange( el: @ )
  @

class Phalange extends Backbone.View
  initialize: ->
    @text = @$el.text()

  events:
    "click": "append"
    "submit": "hideForm"
    "focusout": "submit"

  submit: ->
    new_val = @_input().val()
    unless @text is new_val
      @text = new_val
      @$el.trigger 'phalange:submit', @text
    @setText()
    @hideForm()

  setText: ->
    @$el.text @_input().val()

  hideForm: ->
    @_phalange().hide()

  append: ->
    unless @_phalange_present()
      @$el.text ''
      @$el.append @_$form()
      @_input().focus()

  _phalange_present: ->
    @_phalange().length is 1

  _phalange: ->
    @$el.find('.phalange-form')

  _input: ->
    @$el.find('input')

  _$form: ->
    template = """
      <form class= 'phalange-form' action='javascript:void(0)'>
        <input type='text' value="#{@text}">
        </input>
      </form>
    """
    $(template)

if module?
  module.exports = Phalange
else
  window.Phalange = Phalange
