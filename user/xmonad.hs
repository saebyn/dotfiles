{-# LANGUAGE FlexibleContexts #-}
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad

import qualified XMonad.StackSet as W
import XMonad.ManageHook
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout.Tabbed
import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen

import XMonad.Actions.SpawnOn

import XMonad.Hooks.UrgencyHook
import XMonad.Util.NamedWindows
import XMonad.Util.Run

import XMonad.Util.Themes (ThemeInfo(..))

import Graphics.X11.ExtraTypes.XF86


data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

-- https://github.com/julianandrews/dotfiles/blob/f7c01b5e5dd6ab664f7f501c12ab93bb19149036/home/.xmonad/lib/Layout.hs#L16
solarizedBase03  = "#002b36"
solarizedBase02  = "#073642"
solarizedBase01  = "#586e75"
solarizedBase00  = "#657b83"
solarizedBase0   = "#839496"
solarizedBase1   = "#93a1a1"
solarizedBase2   = "#eee8d5"
solarizedBase3   = "#fdf6e3"
solarizedYellow  = "#b58900"
solarizedOrange  = "#cb4b16"
solarizedRed     = "#dc322f"
solarizedMagenta = "#d33682"
solarizedViolet  = "#6c71c4"
solarizedBlue    = "#268bd2"
solarizedCyan    = "#2aa198"
solarizedGreen   = "#859900"


instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset

        safeSpawn "notify-send" [show name, "workspace " ++ idx]

myScratchpads =
    [ NS "top" "urxvtc -e top" (title =? "top")                        defaultFloating
    , NS "vimwiki" "gvim -c 'set title titlestring=vimwiki|call vimwiki#base#goto_index(v:count1)'" (title =? "vimwiki")               defaultFloating
    , NS "alsamixer" "urxvtc -e alsamixer -c 0" (title =? "alsamixer") defaultFloating
    , NS "wicd" "wicd-gtk -n" (title =? "Wicd Network Manager")                                                              defaultFloating
    ]
 


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
    fg      = "'" ++ solarizedCyan ++ "'" -- n.b quoting
    bg      = "'" ++ solarizedBase02 ++ "'"
    font    = "'xft:Fira Code:pixelsize=18'"
    flags   = "-e 'onstart=lower' -w 1920 -ta l -fg " ++ fg ++ " -bg " ++ bg ++ " -fn " ++ font


myConfig = defaultConfig {
        terminal = myTerminal
      , modMask = mod4Mask
      , layoutHook = myLayout
      , manageHook = manageSpawn <+> myManageHooks
      , workspaces = map show [1..9]
      , focusFollowsMouse  = False
      , clickJustFocuses   = False
      , normalBorderColor = solarizedBase03
      , focusedBorderColor = solarizedCyan
      , startupHook = do
          setWMName "LG3D"
      } `additionalKeysP` myKeys `additionalKeys` extraKeys


myTabConfig = defaultTheme {
                             fontName            = "xft:Fira Code:pixelsize=18"
                           , activeColor         = solarizedCyan
                           , activeBorderColor   = solarizedBase03
                           , activeTextColor     = solarizedBase03
                           , inactiveColor       = solarizedBase02
                           , inactiveBorderColor = solarizedBase03
                           , inactiveTextColor   = solarizedBase00
                           , urgentColor         = solarizedRed
                           , urgentBorderColor   = solarizedRed
                           , urgentTextColor     = solarizedRed
                           , decoHeight          = 27
                           }


myPromptConfig = def {
        font = "xft:Fira Code:pixelsize=18"
      , position = Bottom
      , fgColor  = solarizedCyan
      , bgColor  = solarizedBase02
      , fgHLight = solarizedRed
      , bgHLight = solarizedBase03
      , borderColor = solarizedBase03
      }



myKeys = [ ("M-p", shellPrompt myPromptConfig)
         , ("M-S-/", spawn "xdg-open https://wiki.haskell.org/wikiupload/d/d6/Xmbindings.svg")
         , ("M-C-n", namedScratchpadAction myScratchpads "vimwiki")
         , ("M-C-m", namedScratchpadAction myScratchpads "alsamixer")
         , ("M-C-t", namedScratchpadAction myScratchpads "top")
         , ("M-C-w", namedScratchpadAction myScratchpads "wicd")
         ]

extraKeys = [
           -- Change volume
           ((0, xF86XK_AudioRaiseVolume), spawn "pamixer --increase 5"),
           ((0, xF86XK_AudioLowerVolume), spawn "pamixer --decrease 5"),
           ((0, xF86XK_AudioMute), spawn "pamixer --toggle-mute")
         ]


myTerminal = "urxvtc"


myLayout = tabs ||| avoidStruts (tile ||| mtile) ||| full
    where tabs = renamed [Replace "[T]"] $ tabbed shrinkText myTabConfig
          tile = renamed [Replace "[]="] $ Tall 1 (3/100) (1/2)
          mtile = renamed [Replace "[M]="] $ Mirror tile
          full = renamed [Replace "[ ]="] $ noBorders (fullscreenFull Full)

myManageHooks = composeAll
    [ isFullscreen --> doFullFloat
    , className =? "Gimp" --> doFloat
    , title     =? "plasma-desktop" --> doIgnore
    ]
