module Functions (Book(..), filterByAuthor, filterByGenre, filterByRating, orderByDateRead) where

import Data.List
import Data.Ord
import Data.Time
import Database.SQLite.Simple (ToRow(..), FromRow(..), field, toRow)

data Book = Book { 
 bookId :: Int,
 name :: String, 
 author :: String, 
 releaseDate :: Int, 
 readDate :: Day,
 genre :: String,
 rating :: Double
} deriving (Show)

-- filtra por autor
filterByAuthor :: [Book] -> String -> [Book]
filterByAuthor books a = filter (\b -> a == author b) books

-- filtra por gênero
filterByGenre :: [Book] -> String -> [Book]
filterByGenre books g = filter (\b -> g == genre b) books

-- filtra por avaliação | >= r
filterByRating :: [Book] -> Double -> [Book]
filterByRating books r = filter (\b -> r >= rating b) books

-- ordena por data lida | variavel bool True para mais antigos False para mais recentes
orderByDateRead :: [Book] -> Bool -> [Book]
orderByDateRead books True = sortBy (comparing readDate) books
orderByDateRead books False = sortBy (comparing (Down . readDate)) books


instance FromRow Book where
    fromRow = Book <$> field <*> field <*> field <*> field <*> field <*> field <*> field


instance ToRow Book where
    toRow (Book bid n a r rd g rt) = toRow (bid, n, a, r, rd, g, rt)