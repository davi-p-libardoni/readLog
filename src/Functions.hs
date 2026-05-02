module Functions (Book(..), filterByAuthor, filterByGenre, filterByRating, orderByDateRead, filterByMonthRead, filterByYearRead, pagesByMonth, pagesByYear) where

import Data.List
import Data.Ord
import Data.Time
import Database.PostgreSQL.Simple.FromRow (FromRow(..),field)
import Database.PostgreSQL.Simple.ToRow (ToRow(..), toRow)

data Book = Book { 
 bookId :: Int,
 name :: String, 
 author :: String, 
 releaseDate :: Int, 
 readDate :: Day,
 genre :: String,
 rating :: Double,
 pages :: Int
} deriving (Show)

-- filtra por autor
filterByAuthor :: [Book] -> String -> [Book]
filterByAuthor books a = filter (\b -> a == author b) books

-- filtra por gênero
filterByGenre :: [Book] -> String -> [Book]
filterByGenre books g = filter (\b -> g == genre b) books

-- filtra por avaliação | >= r
filterByRating :: [Book] -> Double -> [Book]
filterByRating books r = filter (\b -> rating b >= r) books

-- ordena por data lida | variavel bool True para mais antigos False para mais recentes
orderByDateRead :: [Book] -> Bool -> [Book]
orderByDateRead books True = sortBy (comparing readDate) books
orderByDateRead books False = sortBy (comparing (Down . readDate)) books

-- filtra por mês
filterByMonthRead :: [Book] -> Int -> Int -> [Book]
filterByMonthRead books month year = filter match books
    where
        match book =
            let 
                (y,m,_) = toGregorian(readDate book)
            in m == month && y == fromIntegral year

-- filtra por ano
filterByYearRead :: [Book] -> Int -> [Book]
filterByYearRead books year = filter match books
    where
        match book =
            let
                (y,_,_) = toGregorian(readDate book)
            in y == fromIntegral year

-- numero de paginas lidas por mês (conta simples, contabiliza o livro inteiro no mês que foi marcado como completo)
pagesByMonth :: [Book] -> Int -> Int -> Int
pagesByMonth books month year = sum (map pages (filterByMonthRead books month year))

-- paginas lidas em um ano
pagesByYear :: [Book] -> Int -> Int
pagesByYear books year = sum (map pages (filterByYearRead books year))

-- conversão de row do banco de dados para o tipo Book
instance FromRow Book where
    fromRow = Book <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field

-- conversão do tipo Book para row do db
instance ToRow Book where
    toRow (Book bid n a r rd g rt pgs) = toRow (bid, n, a, r, rd, g, rt, pgs)