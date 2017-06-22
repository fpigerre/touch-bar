TouchBarView = require './touch-bar-view'
{CompositeDisposable} = require 'atom'
{app, BrowserWindow, TouchBar} = require 'remote'
{TouchBarLabel, TouchBarButton, TouchBarSpacer} = TouchBar

module.exports = touchBar =
  touchBarView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @touchBarView = new TouchBarView(state.OOtouchBarViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @touchBarView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'touch-bar:toggle': => @toggle()
    
    textView = new TouchBarLabel()
    textView.label = "Touch Bar"
    
    touchBar = new TouchBar([
      textView
    ])
    
    atom.getCurrentWindow().setTouchBar(touchBar)

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @touchBarView.destroy()

  serialize: ->
    touchBarViewState: @touchBarView.serialize()

  toggle: ->
    console.log 'TouchBar was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
