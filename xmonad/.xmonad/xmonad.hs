-- from http://beginners-guide-to-xmonad.readthedocs.io/configure_xmonadhs.html

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
--noBorders for fullscreen windows (see https://bbs.archlinux.org/viewtopic.php?id=191565)
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.NoBorders   ( noBorders, smartBorders)

userDir = "/home/g0tmk/"
bitmapDir = userDir ++ ".xmonad/xbm/"


--autoStart = userDir ++ ".xmonad/bin/autostart.sh"

main = do
    xmproc <- spawnPipe "xmobar"

    --spawn $ "sh " ++ autoStart

    xmonad $ defaultConfig
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
                 -- screenshot 1 NOTE: hotkey not working - check xK_Print
                 , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s &; echo 'Select area' | show_osd_message")
                 -- screenshot 2: works fine; why doesn't above work?
                 , ((0, xK_Print), spawn "scrot; echo 'Took screenshot!' | show_osd_message")
                 -- Mod+b: toggle fullscreen
                 , ((mod4Mask, xK_b     ), sendMessage ToggleStruts)
                 -- Mod+p: yeganesh NOTE: "$()" syntax will execute the output (yeganesh only outputs the binary's name)
                 --, ((mod4Mask, xK_p), spawn "dmenu_run -fn 'Terminus::pixelsize=12:antialias=0'")
                 , ((mod4Mask, xK_p), spawn "$(~/bin/yeganesh -x -- -nb \"#000000\" -fn \"Terminus::pixelsize=12:antialias=0\")")
                 -- Multimedia keys
                 -- XF86MonBrightnessUp
                 -- NOTE: x220 seems to do this automatically so we need a way to disable it there; for now, I did not add brightness.py to the sudoers file... its a workaround but should be fixed asap
                 , ((0, 0x1008ff02), spawn "sudo ~/bin/brightness increase 10 | show_osd_message")
                 -- XF86MonBrightnessDown
                 , ((0, 0x1008ff03), spawn "sudo ~/bin/brightness decrease 10 | show_osd_message")
                 -- XF86AudioLowerVolume
                 , ((0, 0x1008ff11), spawn "~/bin/volumecontrol decrease 5 | show_osd_message")
                 -- XF86AudioRaiseVolume
                 , ((0, 0x1008ff13), spawn "~/bin/volumecontrol increase 5 | show_osd_message")
                 -- XF86AudioMute
                 , ((0, 0x1008ff12), spawn "~/bin/volumecontrol toggle | show_osd_message")
                 ]
        myWorkspaces = ["1:term","2:web","3","4","5","6","7","8","9:daemons"]


