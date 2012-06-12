import XMonad
import XMonad.Config.Gnome

import XMonad.Actions.RotSlaves
import XMonad.Actions.CycleWS

import XMonad.Util.EZConfig

import XMonad.Layout.Grid
import XMonad.Layout.TwoPane
import XMonad.Hooks.ManageDocks -- avoidStruts for gnome panel

--import System.IO

myLayout = avoidStruts (Mirror (Tall 1 (3/100) (2/3)) ||| TwoPane (3/100) (1/2) ||| Full)

main = do
--  h <- openFile "/home/dlandau/.xmonad/out" WriteMode
--  hPutStrLn h $ show (layoutHook gnomeConfig)
--  hClose h
  xmonad $ gnomeConfig {
         modMask = mod4Mask
       , layoutHook = myLayout
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
