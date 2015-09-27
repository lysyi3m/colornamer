ColornamerDialog = require './colornamer-dialog'
tinycolor        = require 'tinycolor2'
Namer            = require 'color-namer'

module.exports = class ColornamerInput extends ColornamerDialog
  color: null

  constructor: () ->
    selection = atom.workspace.getActiveTextEditor().getSelectedText()
    value = if selection && tinycolor(selection).isValid() then selection else ''

    super
      input: value
      select: true
      placeholder: 'hex, rgb, hsl'
      prompt: 'Enter your color:'
      iconClass: 'icon-arrow-right'

  onConfirm: (text) ->
    if text && tinycolor(text).isValid() && text != @color
      @color = Namer(text).ntc[0].name
      @miniEditor.getModel().setText(@color)
      @promptText.addClass('icon-check')
      @promptText.text('Your awesome color name:')

    else if text && text == @color
      atom.clipboard.write(@color)
      atom.notifications.addSuccess("Color name #{@color} was added to your clipboard!")
      @close()

    else
      @color = null
      @promptText.removeClass('icon-check')
      @promptText.text('Enter your color:')
      @showError('You need to specify a color to get magic works')
