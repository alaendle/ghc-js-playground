module Impl
    ( printId,
      printVal
    ) where

import GHC.JS.Foreign.Callback
import GHC.JS.Prim

foreign import javascript printId :: IO ()

printVal :: IO String -> IO ()
printVal cb = do
  bc' <- syncCallback' $ fmap toJSString cb
  jsPrintVal bc'

foreign import javascript jsPrintVal :: Callback (IO JSVal) -> IO ()

