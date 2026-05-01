import Data.List
import Data.Ord
import Data.Time
import Data.Time.Calendar.Month (Month)

data Book = Book { 
    name :: String, 
    author :: String, 
    releaseDate :: Int, 
    readDate :: Day,
    genre :: String,
    rating :: Double
} deriving (Show)

-- Parametros: Nome, Autor, Ano de Lançamento, Dia lido
bookList :: [Book]
bookList = [
    Book { name = "The Way of Kings", author = "Brandon Sanderson", releaseDate = 2010, readDate = fromGregorian 2023 2 10, genre = "Fantasy", rating = 4.56},
    Book { name = "1984", author = "George Orwell", releaseDate = 1960, readDate = fromGregorian 2022 3 7, genre = "Drama", rating = 4.57},
    Book { name = "The Name of the Wind", author = "Patrick Rothfuss",releaseDate = 2007, readDate = fromGregorian 2024 1 8, genre = "Fantasy", rating = 4.52},
    Book { name = "The Lord of the Rings", author = "JRR Tolkien", releaseDate = 1954, readDate = fromGregorian 2023 7 10, genre = "Fantasy", rating = 4.60},
    Book { name = "Children of Time", author = "Adrian Tchaikovsky", releaseDate = 2015, readDate = fromGregorian 2025 2 2, genre = "Sci-Fi", rating = 4.23},
    Book { name = "The Wise Man's Fear", author = "Patrick Rothfuss", releaseDate = 2011, readDate = fromGregorian 2024 8 20, genre = "Fantasy", rating = 4.12}]

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
