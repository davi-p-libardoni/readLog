{-# LANGUAGE OverloadedStrings #-}
module DBAccess (initDB,insertBook,getBooks) where

import Database.PostgreSQL.Simple
import Data.Int (Int64)
import Functions (Book(..), BookInput(..))

-- Initialize database
initDB :: Connection -> IO Int64
initDB conn = execute_ conn
    "CREATE TABLE IF NOT EXISTS books \
    \ (id SERIAL PRIMARY KEY, \
    \  name TEXT NOT NULL, \
    \  author TEXT NOT NULL, \
    \  release_date INTEGER, \
    \  read_date DATE, \
    \  status TEXT, \
    \  genre TEXT, \
    \  rating REAL, \
    \  pages INTEGER)"

insertBook :: Connection -> BookInput -> IO Int64
insertBook conn book =
  execute conn
    "INSERT INTO books (name, author, release_date, read_date, status, genre, rating, pages) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    (inName book, inAuthor book, inReleaseDate book, inReadDate book, inStatus book, inGenre book, inRating book, inPages book)

getBooks :: Connection -> IO [Book]
getBooks conn = query_ conn "SELECT id, name, author, release_date, read_date, status, genre, rating, pages FROM books"