module Lib
    ( someFunc
    ) where

import Impl

someFunc :: IO ()
someFunc = do
    printId
    printVal $ pure "Haskell callback!"
