{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
import qualified Data.Text as T
import qualified Data.Text.IO as T.IO
import Network.Wai
import Network.HTTP.Types
import Network.Wai.Handler.Warp (run)
import GHC.Generics
import Data.Aeson (ToJSON, FromJSON, fromEncoding, toEncoding)
import Control.Applicative (liftA2)
newtype Comment = Comment { text :: T.Text } deriving (Generic, Show)

instance ToJSON Comment
instance FromJSON Comment

hello = Comment { text = "json hello world" }

jsonResponse :: ToJSON a => a -> Response
jsonResponse = responseBuilder
    status200
    [(hContentType, "application/json")]
    . fromEncoding . toEncoding

logginStdout :: T.Text -> IO ()
logginStdout = T.IO.putStrLn

app :: Application
app req respond = liftA2 (*>) logginStdout (respond . jsonResponse) ((head . pathInfo) req)

main :: IO ()
main = do
    putStrLn $ "http://localhost:8080/"
    run 8080 app