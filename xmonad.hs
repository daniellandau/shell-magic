import XMonad
import XMonad.Config.Gnome

--import XMonad.Actions.CycleWindows
import XMonad.Actions.RotSlaves
import XMonad.Actions.CycleWS

import XMonad.Util.EZConfig

import XMonad.Layout.Grid
import XMonad.Layout.Circle
import XMonad.Layout.TwoPane


--import System.IO

myLayout = Full ||| Grid ||| TwoPane (3/100) (1/2)

main = do
  -- h <- openFile "/home/dlandau/.xmonad/out" WriteMode
  -- hPutStrLn h $ show (layoutHook gnomeConfig)
  -- hClose h
  xmonad $ gnomeConfig {
         modMask = mod4Mask
--       , layoutHook = myLayout
       } `additionalKeysP`
       [ ("M-C-j", rotAllDown)
       , ("M-C-k", rotAllUp)
       , ("M-<Right>", nextWS)
       , ("M-<Left>",  prevWS)
       , ("M-S-<Right>", shiftToNext)
       , ("M-S-<Left>",  shiftToPrev)
       , ("M-S-C-<Right>", shiftToNext >> nextWS)
       , ("M-S-C-<Left>",  shiftToPrev >> prevWS)
       ]
