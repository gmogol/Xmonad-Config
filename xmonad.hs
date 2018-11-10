import XMonad
import XMonad.Config.Gnome -- needed for gnome
import XMonad.Hooks.ManageDocks -- needed for docks?
import XMonad.Util.EZConfig -- no idea
import Control.Monad (liftM2) -- no idea
import qualified XMonad.StackSet as W -- needed for viewShift
import Data.List -- needed for various things 
import XMonad.Actions.CycleRecentWS -- needed for most recent workspace shift
import XMonad.Hooks.Place -- needed for placing floating windows
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CopyWindow
import XMonad.Hooks.SetWMName -- needed for setting WMName duh!





-- use "xprop  WM_CLASS" to find the class
-- use "xprop WM_NAME" to find the title

-- placement should be -after- doFloat *but*
-- Hooks are applied from right to left so it should be
-- -before- in the list

myManageHook = composeAll . concat $  
  [  [ fmap ( t `isInfixOf`) title --> placeHook myPlacement  | t <- anywhereFloatsT]
   , [ fmap ( t `isInfixOf`) title --> doFloat | t <- anywhereFloatsT]
   ---
   , [ className =? c --> viewShift "w6:tmp"  | c <- w6Classes ]
   , [ title =? t --> viewShift "w6:tmp" | t <- w6Titles ]
   ---
   , [ title =? "xeyes" --> doIgnore ]
   , [ fmap ( "Thunderbird" `isInfixOf`) title --> doShift "w2:mail" ]
   , [ className =? "Emacs" --> viewShift "w3:emacs" ]
   , [ className =? "Google-chrome" --> viewShift "w1:web" ]
   , [ manageDocks ] -- Important for bars don't delete
   ]
  where viewShift = doF . liftM2 (.) W.greedyView W.shift
        w6Titles = ["GNOME Tweaks","Settings" ]
        w6Classes = [ "Nautilus"]
        anywhereFloatsT = [ "Write", "Task", "Gnuplot" ]
        myPlacement = withGaps (16,0,16,0) (smart (0.5,0.5))


        

myKeys =     [ ((mod4Mask, xK_p), spawn "rofi -combi-modi window,drun -show combi -modi combi")
    , ((mod4Mask .|. controlMask, xK_l),  spawn "gnome-screensaver-command --lock")
    , ((mod4Mask .|. shiftMask, xK_q),  spawn "killall chrome; gnome-session-quit --power-off")
    , ((mod4Mask .|. controlMask, xK_o),  spawn "killall chrome; gnome-session-quit --logout --no-prompt")
    , ((mod4Mask, xK_f), spawn "~/.local/share/rofi/zzzfoo.py -e='-mime:text/plain -mime: message/rfc822 -mime:application/javascript' -o xdg-open")
--    , ((mod4Mask, xK_b), cycleRecentWS [xK_space] xK_Tab xK_q) -- need to think about it
    ]

myWorkspaces = ["w1:web","w2:mail","w3:emacs","w4:music","w5:ham","w6:tmp","w7:dvi","8","9","0","-","="]       


main = do
  xmonad $ gnomeConfig{
    modMask = mod4Mask
   , workspaces = myWorkspaces
   , manageHook = myManageHook <+> manageHook defaultConfig
--   , handleEventHook = fullscreenEventHook -- handles fullscreen stuff breaks rofi
  , startupHook = setWMName "LG3D" -- deals with java applets e.g. geogebra
   }`additionalKeys`myKeys
  
