{CompositeDisposable} = require 'atom'
ColornamerInput       = require './colornamer-input'

module.exports =
  config:
    format:
      title: 'Name format'
      description: 'This will affect the output format of copied name in your clipboard'
      type: 'string'
      default: ''
      enum: ['', 'camelcase', 'snakecase', 'startcase', 'kebabcase']

  activate: =>
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'colornamer:show': ->
        Input = new ColornamerInput()
        Input.attach()

  deactivate: =>
    @subscriptions.dispose()
