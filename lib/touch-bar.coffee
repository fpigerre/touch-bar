TouchBarView = require './touch-bar-view'
{CompositeDisposable} = require 'atom'
{app, BrowserWindow, TouchBar, nativeImage} = require 'remote' # Electron
ElectronNamedImage = require 'electron-named-image'
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
    
    # For all template images: http://hetima.github.io/fucking_nsimage_syntax/
    sideBarButton = new TouchBarButton({
      icon: nativeImage.createFromBuffer(ElectronNamedImage.getImageNamed('NSTouchBarSidebarTemplate', true)),
      click: () => atom.commands.dispatch(atom.views.getView(atom.workspace), 'tree-view:toggle')
    })
    
    commentButton = new TouchBarButton({
      label: '/ /',
      click: () => atom.workspace.getActiveTextEditor().insertText('//')
    })
    
    foldButton = new TouchBarButton({
      icon: nativeImage.createFromBuffer(ElectronNamedImage.getImageNamed('NSTouchBarGoDownTemplate', true)),
      click: () =>
        if atom.workspace.getActiveTextEditor().isFoldedAtCursorRow()
          atom.workspace.getActiveTextEditor().unfoldCurrentRow()
        else
          atom.workspace.getActiveTextEditor().foldCurrentRow()
    })
    
    touchBar = new TouchBar([
      sideBarButton,
      new TouchBarSpacer({size: 'medium'}),
      commentButton,
      new TouchBarSpacer({size: 'medium'}),
      foldButton
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
