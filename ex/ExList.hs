module ExList where

import qualified Data.List as L
import qualified Data.Char as C
import qualified Prelude as P
import Prelude
    ( Char , String , Int , Integer , Double , Float , Bool(..)
    , Num(..) , Integral(..) , Enum(..) , Ord(..) , Eq(..)
    , not , (&&) , (||)
    , (.) , ($)
    , flip , curry , uncurry
    , otherwise , error , undefined
    )

head :: [a] -> a
head [] = error "Unable to get head of an empty list"
head (x : _) = x

tail :: [a] -> [a]
tail [] = error "Unable to get head of an empty list"
tail (_ : xs) = xs

null :: [a] -> Bool
null [] = True
null _ = False

length :: Integral i => [a] -> i
length [] = 0
length (_ : xs) = 1 + length xs

sum :: Num a => [a] -> a
sum [] = 0
sum (x : xs) = x + (sum xs)

product :: Num a => [a] -> a
product [] = 1
product (x : xs) = x * product xs

reverse :: [a] -> [a]
reverse [] = []
reverse (x : xs) = reverse xs <: x

(++) :: [a] -> [a] -> [a]
(++) [] xs = xs
(++) (x : xs) ys = x : xs ++ ys 

infixr 5 ++

append :: a -> [a] -> [a]
append x ys = ys ++ [x]

(<:) :: [a] -> a -> [a]
(<:) = flip append

minimum :: Ord a => [a] -> a
minimum [] = error "Empty list does not have minimum"
minimum [x] = x
minimum (x : xs) = min x (minimum xs)

maximum :: Ord a => [a] -> a
maximum [] = error "Empty list does not have maximum"
maximum [x] = x
maximum (x : xs) = max x (maximum xs)

take :: Integral l => l -> [a] -> [a]
take _ [] = []
take 0 _ = []
take n (x : xs) = x : take (n - 1) xs

drop :: Integral l => l -> [a] -> [a]
drop _ [] = []
drop 0 xs = xs
drop n (_ : xs) = drop (n - 1) xs 

takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile _ [] = []
takeWhile f (x : xs)
    | f x = x : takeWhile f xs
    | otherwise = []

tails :: [a] -> [[a]]
tails [] = [[]]
tails xs@(_ : xs') = xs : tails xs'

init :: [a] -> [a]
init [] = error "Unable to get init of an empty list"
init [x] = []
init (x : xs) = x : init xs 

inits :: [a] -> [[a]]
inits [] = [[]]
inits xs = inits (init xs) <: xs

-- subsequences

any :: (a -> Bool) -> [a] -> Bool
any _ [] = False
any p (x : xs) = p x || any p xs

all :: (a -> Bool) -> [a] -> Bool
all _ [] = True
all p (x : xs) = p x && all p xs

and :: [Bool] -> Bool
and [] = True
and (x : xs) = x && and xs

or :: [Bool] -> Bool
or [] = False
or (x : xs) = x || or xs

concat :: [[a]] -> [a]
concat [] = []
concat (xs : xss) = xs ++ concat xss

elem :: Eq a => a -> [a] -> Bool
elem x ys = any (== x) ys

-- elem': same as elem but elementary definition
-- (without using other functions except (==))
elem' :: Eq a => a -> [a] -> Bool
elem' _ [] = False
elem' x (y : ys) = x == y || elem' x ys

(!!) :: Integral i => [a] -> i -> a
(!!) [] _ = error "Index out of range"
(!!) [x] 0 = x
(!!) (x : xs) i = xs !! (i - 1)

filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter p (x : xs)
    | p x = x : xs'
    | otherwise = xs'
    where
        xs' = filter p xs

map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x : xs) = f x : map f xs

(**) :: Integral n => [a] -> n -> [a]
(**) [] _ = []
(**) _ 0 = []
(**) xs n = xs ++ (xs ** (n - 1))

cycle :: [a] -> [a]
cycle xs = xs ++ cycle xs

repeat :: a -> [a]
repeat x = x : repeat x

replicate :: Int -> a -> [a]
replicate n x 
    | n > 0 = x : replicate (n - 1) x
    | otherwise = []

-- isPrefixOf
-- isInfixOf
-- isSuffixOf

zip :: [a] -> [b] -> [(a, b)]
zip (x : xs) (y : ys) = (x, y) : zip xs ys
zip _ _ = []

zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith f (x:xs) (y:ys) = (f x y) : zipWith f xs ys
zipWith _ _ _ = []

-- intercalate
-- nub

splitAt :: Integral x => x -> [a] -> ([a],[a])
splitAt 0 xs = ([],xs)
splitAt n (x:xs) = (x:ls, rs)
    where
        (ls,rs) = splitAt (n - 1) xs

-- break

-- lines
-- words
-- unlines
-- unwords

{-
checks if the letters of a phrase form a palindrome.
See below for examples of palindromes:
"Madam, I'm Adam"
"Step on no pets."
"Mr. Owl ate my metal worm."
"Was it a car or a cat I saw?"
"Doc, note I dissent.  A fast never prevents a fatness.  I diet on cod."
-}

upperLetters :: String
upperLetters = ['A'..'Z']

palindrome :: String -> Bool
palindrome s = reverse s' == s'
    where
        s' = filter (`elem` upperLetters) (map C.toUpper s)