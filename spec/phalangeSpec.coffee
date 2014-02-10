describe "Phalange", ->

  describe "#edit", ->
    $el = null

    beforeEach ->
      $el = $("<div class='original'>Original Content</div>")
      $('body').append $el
      $el.edit()

    it "is defined as a jQuery function", ->
      expect($el.edit).toBeDefined()

    describe "when clicked", ->
      $el = null

      beforeEach ->
        $el.click()

      afterEach ->
        $("body").html ""

      it "hides itself", ->
        expect( $el.text() ).not.toMatch 'Original Content'

      it "displays a form", ->
        form = $('body').find '.phalange-form'
        expect(form.length).toEqual 1

      it "pre-loads the form with its original content", ->
        field = $('.phalange-form input')
        expect(field.val()).toEqual "Original Content"

      it "pre-selects the form element", ->
        expect(document.activeElement).toEqual(document.querySelector('.phalange-form input'))

    describe "when submitted", ->
      originalText = null

      beforeEach ->
        originalText = $el.text()
        $el.click()

      Testable =
        stub: (e, text) ->
          expect(text).toEqual "New Value"

      it "publishes the current value of the field", ->
        spy = spyOn(Testable, "stub").andCallThrough()

        $el.on 'phalange:submit', Testable.stub

        $el.find("input").val("New Value")
        $('.phalange-form').trigger 'submit'

        expect(spy).toHaveBeenCalled()

      it "hides the form", ->
        $form = $('.phalange-form')
        $form.trigger 'submit'

        expect($form.css 'display' ).toEqual 'none'

      it "populates the element with the submitted text", ->
        $el.find("input").val("New Text")
        $('.phalange-form').trigger 'submit'

        expect($el.text()).toEqual "New Text"
