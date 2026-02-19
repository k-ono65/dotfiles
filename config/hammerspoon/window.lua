-- window.lua
-- Vimライクなウィンドウ操作

local M = {}

-- 修飾キー（Ctrl+Cmd）
local modifier = {"ctrl", "cmd"}
-- モニター移動用修飾キー（Ctrl+Cmd+Shift）
local modifierShift = {"ctrl", "cmd", "shift"}

-- ウィンドウの履歴を保存するテーブル（スタック形式）
local undoStack = {}  -- undoStack[windowId] = {frame1, frame2, ...}
local redoStack = {}  -- redoStack[windowId] = {frame1, frame2, ...}

-- スタック初期化ヘルパー
local function ensureStacks(id)
  if not undoStack[id] then undoStack[id] = {} end
  if not redoStack[id] then redoStack[id] = {} end
end

-- 元に戻す (undo)
local function undoWindow()
  local win = hs.window.focusedWindow()
  if not win then return end

  local id = win:id()
  ensureStacks(id)

  if #undoStack[id] > 0 then
    -- 現在の状態をredoスタックに保存
    table.insert(redoStack[id], win:frame():copy())
    -- undoスタックから復元
    local prevFrame = table.remove(undoStack[id])
    win:setFrame(prevFrame)
  end
end

-- やり直す (redo)
local function redoWindow()
  local win = hs.window.focusedWindow()
  if not win then return end

  local id = win:id()
  ensureStacks(id)

  if #redoStack[id] > 0 then
    -- 現在の状態をundoスタックに保存
    table.insert(undoStack[id], win:frame():copy())
    -- redoスタックから復元
    local nextFrame = table.remove(redoStack[id])
    win:setFrame(nextFrame)
  end
end

-- ウィンドウを画面の指定位置に配置するヘルパー関数
local function moveWindow(position)
  local win = hs.window.focusedWindow()
  if not win then return end

  -- 移動前の状態をundoスタックに保存
  local id = win:id()
  ensureStacks(id)
  table.insert(undoStack[id], win:frame():copy())
  -- 新しい操作をしたらredoスタックはクリア
  redoStack[id] = {}

  local f = win:frame()
  local screen = win:screen():frame()

  if position == "left" then
    f.x = screen.x
    f.y = screen.y
    f.w = screen.w / 2
    f.h = screen.h
  elseif position == "right" then
    f.x = screen.x + screen.w / 2
    f.y = screen.y
    f.w = screen.w / 2
    f.h = screen.h
  elseif position == "up" then
    f.x = screen.x
    f.y = screen.y
    f.w = screen.w
    f.h = screen.h / 2
  elseif position == "down" then
    f.x = screen.x
    f.y = screen.y + screen.h / 2
    f.w = screen.w
    f.h = screen.h / 2
  elseif position == "maximize" then
    f.x = screen.x
    f.y = screen.y
    f.w = screen.w
    f.h = screen.h
  elseif position == "center" then
    f.w = screen.w * 0.6
    f.h = screen.h * 0.7
    f.x = screen.x + (screen.w - f.w) / 2
    f.y = screen.y + (screen.h - f.h) / 2
  end

  win:setFrame(f)
end

-- ウィンドウを別モニターに移動するヘルパー関数
local function moveToScreen(direction)
  local win = hs.window.focusedWindow()
  if not win then return end

  -- 移動前の状態をundoスタックに保存
  local id = win:id()
  ensureStacks(id)
  table.insert(undoStack[id], win:frame():copy())
  redoStack[id] = {}

  local currentScreen = win:screen()
  local targetScreen

  if direction == "west" then
    targetScreen = currentScreen:toWest() or currentScreen
  elseif direction == "east" then
    targetScreen = currentScreen:toEast() or currentScreen
  elseif direction == "north" then
    targetScreen = currentScreen:toNorth() or currentScreen
  elseif direction == "south" then
    targetScreen = currentScreen:toSouth() or currentScreen
  end

  if targetScreen and targetScreen ~= currentScreen then
    win:moveToScreen(targetScreen)
  end
end

-- Vimライクなキーバインド
-- h: 左半分
hs.hotkey.bind(modifier, "h", function() moveWindow("left") end)
-- l: 右半分
hs.hotkey.bind(modifier, "l", function() moveWindow("right") end)
-- k: 上半分
hs.hotkey.bind(modifier, "k", function() moveWindow("up") end)
-- j: 下半分
hs.hotkey.bind(modifier, "j", function() moveWindow("down") end)
-- m: 最大化
hs.hotkey.bind(modifier, "m", function() moveWindow("maximize") end)
-- c: 中央配置
hs.hotkey.bind(modifier, "c", function() moveWindow("center") end)
-- u: 元に戻す (undo)
hs.hotkey.bind(modifier, "u", function() undoWindow() end)
-- r: やり直す (redo)
hs.hotkey.bind(modifier, "r", function() redoWindow() end)

-- 音声入力トグル
-- s: 音声入力（Speech）
hs.hotkey.bind(modifier, "s", function()
  -- fnキー2回を送信
  hs.eventtap.event.newSystemKeyEvent("EJECT", true):post()
  hs.eventtap.event.newSystemKeyEvent("EJECT", false):post()
  hs.timer.usleep(50000)
  hs.eventtap.event.newSystemKeyEvent("EJECT", true):post()
  hs.eventtap.event.newSystemKeyEvent("EJECT", false):post()
end)

-- モニター間移動（Ctrl+Cmd+Shift）
-- h: 左のモニターへ
hs.hotkey.bind(modifierShift, "h", function() moveToScreen("west") end)
-- l: 右のモニターへ
hs.hotkey.bind(modifierShift, "l", function() moveToScreen("east") end)
-- k: 上のモニターへ
hs.hotkey.bind(modifierShift, "k", function() moveToScreen("north") end)
-- j: 下のモニターへ
hs.hotkey.bind(modifierShift, "j", function() moveToScreen("south") end)

return M
