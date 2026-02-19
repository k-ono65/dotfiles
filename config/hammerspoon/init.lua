hs.application.enableSpotlightForNameSearches(true)
require('alacritty')
require('window')

hs.hotkey.bind({ "cmd" }, "U", function()
  hs.execute("toggle_opacity", true)
end)
