module Impl
    ( printId
    ) where

foreign import javascript printId :: IO ()
