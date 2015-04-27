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

import Graphics.X11.ExtraTypes.XF86


main = do
    spawn $ "conky"
    xmonad =<< myDzen myConfig


toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )


myDzen conf = statusBar ("dzen2 " ++ flags) dzenPP toggleStrutsKey conf
 where
    fg      = "'#a8a3f7'" -- n.b quoting
    bg      = "'#000000'"
    font    = "'-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*'"
    flags   = "-e 'onstart=lower' -w 1920 -ta l -fg " ++ fg ++ " -bg " ++ bg ++ " -fn " ++ font


myConfig = defaultConfig {
        terminal = myTerminal
      , layoutHook = myLayout
      , manageHook = manageSpawn <+> myManageHooks
      , workspaces = ["browser", "editor", "mixer", "top", "network"] ++ map show [5..9]
      , startupHook = do
          setWMName "LG3D"
          spawnOn "browser" "chromium-browser"
          spawnOn "editor" "urxvt -e tmux"
          spawnOn "mixer" "urxvt -e alsamixer -c 0"
          spawnOn "top" "urxvt -e top"
          spawnOn "network" "urxvt -e bmon"
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
