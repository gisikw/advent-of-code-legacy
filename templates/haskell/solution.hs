import System.Environment (getArgs)

main :: IO ()
main = do
  (inputFile:part:_) <- getArgs
  input <- readFile inputFile
  if part == "1"
    then putStrLn "Part 1 not yet implemented"
    else putStrLn "Part 2 not yet implemented"
