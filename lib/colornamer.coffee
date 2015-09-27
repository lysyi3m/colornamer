{CompositeDisposable} = require 'atom'
ColornamerInput       = require './colornamer-input'

module.exports = colornamer =
  activate: () ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'colornamer:toggle': =>
        Input = new ColornamerInput()
        Input.attach()

  deactivate: () ->
    @subscriptions.dispose()
