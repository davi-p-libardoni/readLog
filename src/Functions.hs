module Functions (Book(..), filterByAuthor, filterByGenre, filterByRating, orderByDateRead) where

import Data.List
import Data.Ord
import Data.Time
import Data.Time.Calendar.Month
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
filterByRating books r = filter (\b -> r >= rating b) books

-- ordena por data lida | variavel bool True para mais antigos False para mais recentes
orderByDateRead :: [Book] -> Bool -> [Book]
orderByDateRead books True = sortBy (comparing readDate) books
orderByDateRead books False = sortBy (comparing (Down . readDate)) books

-- filtra por mês
filterByMonthRead :: [Book] -> YearMonth -> [Book]
filterByMonthRead books ym = filter match books
    where
        match book =
            let 
                (y,m,_) = toGregorian(readDate book)
                YearMonth year month = ym
            in m == month && y == year

-- numero de paginas lidas por mês (conta simples, contabiliza o livro inteiro no mês que foi marcado como completo)
pagesByMonth :: [Book] -> YearMonth -> Int
pagesByMonth books ym = sum $ filterByMonthRead books ym

-- conversão de row do banco de dados para o tipo Book
instance FromRow Book where
    fromRow = Book <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*>

-- conversão do tipo Book para row do db
instance ToRow Book where
    toRow (Book bid n a r rd g rt pgs) = toRow (bid, n, a, r, rd, g, rt pgs)