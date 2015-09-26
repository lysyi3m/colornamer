ColornameView = require './colorname-view'
{CompositeDisposable} = require 'atom'

module.exports = Colorname =
  colornameView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @colornameView = new ColornameView(state.colornameViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @colornameView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'colorname:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @colornameView.destroy()

  serialize: ->
    colornameViewState: @colornameView.serialize()

  toggle: ->
    console.log 'Colorname was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
