{-# LANGUAGE DeriveDataTypeable #-}

import Control.Monad.Trans (liftIO)
import qualified Data.ByteString.Lazy as BS
import qualified Data.ByteString.Lazy.UTF8 as B8
import Data.List (intercalate)
import Data.Maybe (fromJust, fromMaybe)
import Network.CGI       -- See http://hackage.haskell.org/package/cgi
import System.Process    -- (createProcess, CreateProcess, proc) 
import System.Exit (ExitCode(ExitSuccess))
import System.IO (readFile, hGetContents, hGetLine, hPutStr, hClose)
import System.IO.Error (isEOFError, tryIOError)
import Text.JSON.Generic

data Result = Result {
      input :: String
    , results :: String
} deriving (Show, Data, Typeable)

page :: String -> String -> String
page p r = encodeJSON $ Result { input = p, results = r }

pmlcheck :: BS.ByteString -> IO String
pmlcheck pml = do
  (Just hin, Just hout, Just herr, jHandle) <-
    createProcess (proc "./pmlcheck" [])
           { cwd = Just "."
           , std_in = CreatePipe
           , std_out = CreatePipe
           , std_err = CreatePipe 
           }

  tryIOError $ BS.hPutStr hin pml
  tryIOError $ hClose hin
  result <- tryIOError $ hGetContents hout
  err <- tryIOError $  hGetContents herr
  ec <- waitForProcess jHandle
  if ec == ExitSuccess
    then case result of
       Right c -> return c
       Left e -> if isEOFError e
                then return ""
                else ioError e

     else case err of
       Right c -> return c
       Left e -> if isEOFError e
                then return ""
                else ioError e


cgiMain :: CGI CGIResult
cgiMain = do
  p <- getInputFPS "editedText"
  p' <- getInput "editedText" >>= (\s -> return $  fromMaybe "" s)
  r <- liftIO $ pmlcheck $ fromJust p
  let o = page p' r in output o

main :: IO ()
main = runCGI $ cgiMain
