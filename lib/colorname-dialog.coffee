{$, TextEditorView, View} = require 'atom-space-pen-views'

module.exports = class Dialog extends View
  @content: ({prompt, placeholder} = {}) ->
    @div class: 'colorname', =>
      @label prompt, class: 'colorname__label icon', outlet: 'promptText'
      @subview 'miniEditor', new TextEditorView(mini: true, placeholderText: placeholder)
      @div class: 'colorname__error-message error-message', outlet: 'errorMessage'

  initialize: ({input, select, iconClass} = {}) ->
    @promptText.addClass(iconClass) if iconClass
    atom.commands.add @element,
      'core:confirm': => @onConfirm(@miniEditor.getText())
      'core:cancel':  => @cancel()
    @miniEditor.on 'blur', => @close()
    @miniEditor.getModel().onDidChange => @showError()
    @miniEditor.getModel().setText(input)

    if select
      range = [[0, 0], [0, input.length]]
      @miniEditor.getModel().setSelectedBufferRange(range)

  attach: ->
    @panel = atom.workspace.addModalPanel(item: this.element)
    @miniEditor.focus()
    @miniEditor.getModel().scrollToCursorPosition()

  close: ->
    panelToDestroy = @panel
    @panel = null
    panelToDestroy?.destroy()
    atom.workspace.getActivePane().activate()

  cancel: ->
    @close()
    atom.commands.dispatch(atom.views.getView(atom.workspace), 'focus')

  showError: (message = '') ->
    if message
      @errorMessage.text(message)
      @errorMessage.show()
    else
      @errorMessage.hide()
