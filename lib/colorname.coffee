{CompositeDisposable} = require 'atom'
ColornameInput        = require './colorname-input'

module.exports = Colorname =
  activate: () ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'colorname:toggle': =>
        Input = new ColornameInput()
        Input.attach()

  deactivate: () ->
    @subscriptions.dispose()
