{-# LANGUAGE OverloadedStrings #-}
module Main where

import Functions
import APICalls (searchBooks)
import DBAccess

import Web.Scotty
import Database.PostgreSQL.Simple
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
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
  initDB conn

  scotty port $ do
    middleware logStdoutDev

    get "/" $ do
      file "static/index.html"

    get "/book/search/:name" $ do
      n <- (param "name" :: ActionM TL.Text)
      result <- liftIO (searchBooks (TL.unpack n))
      json result

  close conn
