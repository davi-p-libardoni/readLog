{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Database.SQLite.Simple
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Functions
import APICalls (searchBooks)
import System.Environment (lookupEnv)
import Text.Read (readMaybe)
import qualified Data.Text.Lazy as TL
import Control.Monad.IO.Class (liftIO)
import Network.HTTP.Types.Status (status502)

-- Initialize database
initDB :: Connection -> IO ()
initDB conn = execute_ conn
  "CREATE TABLE IF NOT EXISTS books \
  \ (id INTEGER PRIMARY KEY AUTOINCREMENT, \
  \  name TEXT NOT NULL, \
  \  author TEXT NOT NULL, \
  \  release_date INTEGER, \
  \  read_date TEXT, \
  \  genre TEXT, \
  \  rating REAL)"

insertBook :: Connection -> Book -> IO ()
insertBook conn book =
  execute conn
    "INSERT INTO books (name, author, release_date, read_date, genre, rating) VALUES (?, ?, ?, ?, ?, ?)"
    (name book, author book, releaseDate book, readDate book, genre book, rating book)


getBooks :: Connection -> IO [Book]
getBooks conn = query_ conn "SELECT id, name, author, release_date, read_date, genre, rating FROM books"

main :: IO ()
main = do
  -- pick port: env PORT (Codespaces/Render/Heroku) or default 3000
  mPort <- lookupEnv "PORT"
  let port = maybe 3000 id (mPort >>= readMaybe)

  conn <- open "books.db"
  initDB conn

  scotty port $ do
    middleware logStdoutDev

    

    get "/book/search/:name" $ do
      n <- (param "name" :: ActionM TL.Text)
      result <- liftIO (searchBooks (TL.unpack n))
      json result

  close conn
