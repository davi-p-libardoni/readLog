{-# LANGUAGE OverloadedStrings #-}
module DBAccess (initDB,insertBook,getBooks) where

import Database.PostgreSQL.Simple
import Data.Int (Int64)
import Functions (Book(..))

-- Initialize database
initDB :: Connection -> IO Int64
initDB conn = execute_ conn
  "CREATE TABLE IF NOT EXISTS books \
  \ (id SERIAL PRIMARY KEY, \
  \  name TEXT NOT NULL, \
  \  author TEXT NOT NULL, \
  \  release_date INTEGER, \
  \  read_date DATE, \
  \  genre TEXT, \
  \  rating REAL)"

insertBook :: Connection -> Book -> IO Int64
insertBook conn book =
  execute conn
    "INSERT INTO books (name, author, release_date, read_date, genre, rating) VALUES (?, ?, ?, ?, ?, ?)"
    (name book, author book, releaseDate book, readDate book, genre book, rating book)

getBooks :: Connection -> IO [Book]
getBooks conn = query_ conn "SELECT id, name, author, release_date, read_date, genre, rating FROM books"