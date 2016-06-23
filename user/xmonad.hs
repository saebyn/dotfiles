{-# LANGUAGE FlexibleContexts #-}
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Util.EZConfig
import XMonad.Actions.SpawnOn

import XMonad.Hooks.UrgencyHook
import XMonad.Util.NamedWindows
import XMonad.Util.Run

import Graphics.X11.ExtraTypes.XF86


data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset

        safeSpawn "notify-send" [show name, "workspace " ++ idx]


main = do
    spawn $ "feh --bg-fill /home/john/Downloads/GykjvD7.png"
    spawn $ "urxvtd"
    spawn $ "conky"
    spawn $ "notify-osd"
    config <- myDzen myConfig
    xmonad
        $ withUrgencyHook LibNotifyUrgencyHook
        $ config


toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )


myDzen conf = statusBar ("dzen2 " ++ flags) dzenPP toggleStrutsKey conf
 where
    fg      = "'#a8a3f7'" -- n.b quoting
    bg      = "'#000000'"
    font    = "'-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*'"
    flags   = "-e 'onstart=lower' -w 1920 -ta l -fg " ++ fg ++ " -bg " ++ bg ++ " -fn " ++ font


myConfig = defaultConfig {
        terminal = myTerminal
      , modMask = mod4Mask
      , layoutHook = myLayout
      , manageHook = manageSpawn <+> myManageHooks
      , workspaces = map show [1..9]
      , focusFollowsMouse  = False
      , clickJustFocuses   = False
      , startupHook = do
          setWMName "LG3D"
          spawnOn "4" "urxvt -e alsamixer -c 0"
          spawnOn "5" "urxvt -e top"
      } `additionalKeysP` myKeys `additionalKeys` extraKeys


myKeys = [ ("M-p", spawn "dmenu_run -b -nb black -nf yellow -sf yellow"),
           ("M-S-/", spawn "chromium https://wiki.haskell.org/wikiupload/d/d6/Xmbindings.svg")
         ]

extraKeys = [
           -- Change volume
           ((0, xF86XK_AudioRaiseVolume), spawn "pamixer --increase 5"),
           ((0, xF86XK_AudioLowerVolume), spawn "pamixer --decrease 5"),
           ((0, xF86XK_AudioMute), spawn "pamixer --toggle-mute")
         ]


myTerminal = "urxvt -e tmux"


myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2))) |||
    noBorders (fullscreenFull Full)

myManageHooks = composeAll
    [ isFullscreen --> doFullFloat
    , className =? "Gimp" --> doFloat
    , title     =? "plasma-desktop" --> doIgnore
    ]
