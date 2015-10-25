ColornamerDialog = require './colornamer-dialog'
tinycolor        = require 'tinycolor2'
Namer            = require 'color-namer'
CamelCase        = require 'lodash.camelcase'
SnakeCase        = require 'lodash.snakecase'
StartCase        = require 'lodash.startcase'
KebabCase        = require 'lodash.kebabcase'

module.exports = class ColornamerInput extends ColornamerDialog
  color: null
  format: atom.config.get 'colornamer.format'
  initialPrompt: 'Enter your color:'
  successPrompt: 'Your awesome color name:'

  constructor: ->
    selection = atom.workspace.getActiveTextEditor().getSelectedText()
    value = if selection && tinycolor(selection).isValid() then selection else ''

    super
      input: value
      select: true
      placeholder: 'hex, rgb, hsl'
      prompt: @initialPrompt
      iconClass: 'icon-arrow-right'

  formatName: (text) ->
    switch @format
      when 'camelcase' then CamelCase(text)
      when 'snakecase' then SnakeCase(text)
      when 'startcase' then StartCase(text)
      when 'kebabcase' then KebabCase(text)
      else text

  onConfirm: (text) ->
    if text && tinycolor(text).isValid() && text != @color
      @color = Namer(text).ntc[0].name
      @miniEditor.getModel().setText @color
      @promptText.addClass('icon-check')
      @promptText.text @successPrompt
      match = (100 - parseInt(Namer(text).ntc[0].distance))
      @matchText.text "Match: #{match}%"

    else if text && text == @color
      atom.clipboard.write @formatName(@color)
      atom.notifications.addSuccess("Color name #{@color} was added to your clipboard!")
      @close()

    else
      @color = null
      @promptText.removeClass('icon-check')
      @promptText.text @initialPrompt
      @matchText.text ''
      @showError('You need to specify a valid color to get magic works')
