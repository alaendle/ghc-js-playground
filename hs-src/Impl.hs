module Impl
    ( printId,
      printVal
    ) where

printId :: IO ()
printId = putStrLn "Hello from Haskell!"

printVal :: IO String -> IO ()
printVal provider = do
    v <- provider
    putStrLn v
