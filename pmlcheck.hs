import Control.Monad.Trans (liftIO)
import Data.List (intercalate)
import Data.Maybe (fromJust)
import Network.CGI       -- See http://hackage.haskell.org/package/cgi
import System.Process    -- (createProcess, CreateProcess, proc) 
import System.Exit (ExitCode(ExitSuccess))
import System.IO (readFile, hGetContents, hGetLine, hPutStr, hClose)
import System.IO.Error (isEOFError, tryIOError)
import Text.XHtml        


page :: Maybe String -> String -> Html
page p r  = 
  let np = intercalate "\n" $ map (\(n, l) -> (show n) ++ ": " ++ l) $ zip [1..] $ lines $ fromJust p in
  body << (h1 << "Results" +++ h3 << "pmlcheck output" +++ pre  << r +++ h3 << "input PML code" +++ pre <<  np)


pmlcheck :: String -> IO String
pmlcheck pml = do
  (Just hin, Just hout, Just herr, jHandle) <-
    createProcess (proc "/home/jnoll/bin/pmlcheck" [])
           { cwd = Just "."
           , std_in = CreatePipe
           , std_out = CreatePipe
           , std_err = CreatePipe 
           }

  tryIOError $ hPutStr hin pml
--  tryIOError $ hClose hin
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
  p <- getInput "editedText"
  r <- liftIO $ pmlcheck $ fromJust  p
  let o = page p r in 
    output $ renderHtml o

main :: IO ()
main = runCGI $ cgiMain
