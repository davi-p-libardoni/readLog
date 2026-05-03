{-# LANGUAGE OverloadedStrings #-}
module Main where

import Functions (Book(..),BookInput(..))
import APICalls (searchBooks)
import DBAccess

import Web.Scotty
import Database.PostgreSQL.Simple
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Network.Wai.Middleware.Static (staticPolicy, addBase)
import System.Environment (lookupEnv)
import Text.Read (readMaybe)
import qualified Data.Text.Lazy as TL
import Control.Monad.IO.Class (liftIO)
import qualified Data.ByteString.Char8 as BS

main :: IO ()
main = do
  -- pick port: env PORT (Codespaces/Render/Heroku) or default 3000
  mPort <- lookupEnv "PORT"
  let port = maybe 3000 id (mPort >>= readMaybe)

  mDbUrl <- lookupEnv "DATABASE_URL"
  dbUrl <- maybe (fail "DATABASE_URL is not set") (pure . BS.pack) mDbUrl
  conn <- connectPostgreSQL dbUrl
  _ <- initDB conn

  scotty port $ do
    middleware logStdoutDev
    middleware (staticPolicy (addBase "static"))

    get "/" $ do
      file "static/readlog.html"

    get "/books" $ do
      books <- liftIO (getBooks conn)
      json books

    get "/book/search" $ do
      q <- (param "q" :: ActionM TL.Text)
      result <- liftIO (searchBooks (TL.unpack q))
      json result
    
    post "/book/add" $ do
      book <- (jsonData :: ActionM BookInput)
      _ <- liftIO (insertBook conn book)
      json ("ok" :: TL.Text)
    
    

  close conn
