ColornamerDialog = require './colornamer-dialog'
tinycolor        = require 'tinycolor2'
Namer            = require 'color-namer'

module.exports = class ColornamerInput extends ColornamerDialog
  color: null
  initialPrompt: 'Enter your color:'
  successPrompt: 'Your awesome color name:'

  constructor: () ->
    selection = atom.workspace.getActiveTextEditor().getSelectedText()
    value = if selection && tinycolor(selection).isValid() then selection else ''

    super
      input: value
      select: true
      placeholder: 'hex, rgb, hsl'
      prompt: @initialPrompt
      iconClass: 'icon-arrow-right'

  onConfirm: (text) ->
    if text && tinycolor(text).isValid() && text != @color
      @color = Namer(text).ntc[0].name
      @miniEditor.getModel().setText @color
      @promptText.addClass('icon-check')
      @promptText.text @successPrompt

    else if text && text == @color
      atom.clipboard.write @color
      atom.notifications.addSuccess("Color name #{@color} was added to your clipboard!")
      @close()

    else
      @color = null
      @promptText.removeClass('icon-check')
      @promptText.text @initialPrompt
      @showError('You need to specify a valid color to get magic works')
