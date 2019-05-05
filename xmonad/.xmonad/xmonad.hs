-- from http://beginners-guide-to-xmonad.readthedocs.io/configure_xmonadhs.html

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
--noBorders for fullscreen windows
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.NoBorders   ( noBorders, smartBorders)

userDir = "/home/g0tmk/"
bitmapDir = userDir ++ ".xmonad/xbm/"


--autoStart = userDir ++ ".xmonad/bin/autostart.sh"

main = do
    --xmproc <- spawnPipe "/home/g0tmk/.cabal/bin/xmobar"
    xmproc <- spawnPipe "xmobar"

    --spawn $ "sh " ++ autoStart

    xmonad $ defaultConfig
        --{ manageHook = manageDocks <+> manageHook defaultConfig
        { manageHook = manageHook defaultConfig <+> manageDocks 
        , layoutHook    = avoidStruts  
                        $ toggleLayouts (noBorders Full)
                        $ smartBorders
                        $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "lightgreen" "" . shorten 50
                        }
        , workspaces = myWorkspaces
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , normalBorderColor = "#444444"
        -- , focusedBorderColor = "#0000dd"
        -- , focusedBorderColor = "#22bb99"
        , focusedBorderColor = "#2299bb"
        , borderWidth = 1
        } `additionalKeys` myKeys
    where 
        myKeys = -- Ctrl+Shift+Z: Lock screen with slock
                 [ ((mod4Mask .|. shiftMask, xK_z), spawn "slock")
                 -- screenshot 1
                 , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
                 -- screenshot 2
                 , ((0, xK_Print), spawn "scrot")
                 -- Mod+b: toggle fullscreen
                 , ((mod4Mask, xK_b     ), sendMessage ToggleStruts)
                 -- Mod+p: dmenu (w/ custom fonts and stuff)
                 --, ((mod4Mask, xK_p), spawn "dmenu_run -fn -*-terminus-*-r-*-*-12-*-*-*-*-*-*-* -nb bisque3 -nf grey35 -sb bisque1 -sf grey10")
                 , ((mod4Mask, xK_p), spawn "dmenu_run -fn 'Terminus::pixelsize=12:antialias=0'")
                 -- Multimedia keys
                 -- XF86MonBrightnessUp
                 --  note: does not work.. does xmonad need some special permissions?
                 --, ((0, 0x1008ff02), spawn "/home/g0tmk/brightness.py increase 10")
                 -- XF86MonBrightnessDown
                 --, ((0, 0x1008ff03), spawn "/home/g0tmk/brightness.py decrease 10")
                 -- XF86AudioLowerVolume
                 , ((0, 0x1008ff11), spawn "amixer set Master 5%-")
                 -- XF86AudioRaiseVolume
                 , ((0, 0x1008ff13), spawn "amixer set Master 5%+")
                 -- XF86AudioMute
                 , ((0, 0x1008ff12), spawn "amixer set Master toggle")
                 ]
        myWorkspaces = ["1:term","2","3","4","5","6","7","8","9:daemons"]
