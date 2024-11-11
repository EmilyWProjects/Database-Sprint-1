--Tables
--Movies
CREATE TABLE IF NOT EXISTS Movies (
    movie_id SERIAL PRIMARY KEY,
    movie_title VARCHAR(255) NOT NULL,
    movie_year INT,
    movie_genre VARCHAR(255),
    movie_director VARCHAR(255)
);

--Customers
CREATE TABLE IF NOT EXISTS Customers (
    customer_id SERIAL PRIMARY KEY,
    customer_fname VARCHAR(255),
    customer_lname VARCHAR(255),
    customer_email VARCHAR(255) UNIQUE NOT NULL,
    customer_phone TEXT
);

--Rentals
CREATE TABLE IF NOT EXISTS Rentals (
    rental_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    movie_id INT REFERENCES Movies(movie_id),
    rentals_rentdate DATE NOT NULL,
    rentals_returndate DATE,
);

--Movies data
INSERT INTO Movies (movie_title, movie_year, movie_genre, movie_director) VALUES
('A Clockwork Orange', 1971, 'Crime', 'Stanley Kubrick'),
('The Blair Witch Project', 1999, 'Horror', 'Daniel Myrick'),
('How the Grinch Stole Christmas', 2000, 'Holiday', 'Ron Howard'),
('Holes', 2003, 'Satire', 'Andrew Davis'),
('Spy', 2015, 'Action', 'Paul Feig')

--Customers data
INSERT INTO Customers (customer_fname, customer_lname, customer_email, customer_phone) VALUES
('Amanda', 'Akerman', 'amanda.akerman@email.com', '111-111-1111'),
('Bartholomew', 'Black', 'bartholomew.black@email.com', '222-222-2222'),
('Cory', 'Cole', 'cory.cole@email.com', '333-333-3333'),
('Darla', 'Darcy', 'darla.darcy@email.com', '444-444-4444'),
('Esther', 'Evans', 'esther.evans@email.com', '555-555-5555')

--Rentals data
INSERT INTO Rentals (customer_id, movie_id, rentals_rentdate, rentals_returndate) VALUES
(1, 1, '2020-01-01', '2020-01-20'),
(1, 5, '2020-02-01', '2020-02-20'),
(2, 1, '2020-03-01', '2020-03-20'),
(2, 3, '2020-04-01', NULL),
(3, 3, '2020-05-01', '2020-05-20'),
(3, 4, '2020-06-01', '2020-06-20'),
(4, 4, '2020-07-01', NULL),
(4, 5, '2020-08-01', '2020-08-20'),
(5, 2, '2020-09-01', NULL),
(5, 5, '2020-10-01', '2020-10-20')


--Customer email query
SELECT Movies.movie_title
FROM Rentals  
JOIN Customers ON Rentals.customer_id = Customers.customer_id
JOIN Movies ON Rentals.movie_id = Movies.movie_id
WHERE Customers.customer_email = $1;

--Customer movie title query
SELECT Customers.customer_fname, Customers.customer_lname
FROM Rentals 
JOIN Customers ON Rentals.customer_id = Customers.customer_id
JOIN Movies ON Rentals.movie_id = Movies.movie_id
WHERE Movies.movie_title = $1;

--Movie rental history query
SELECT Customers.customer_fname, Customers.customer_lname, Rentals.rentals_rentdate, Rentals.rentals_returndate
FROM Rentals
JOIN Customers ON Rentals.customer_id = Customers.customer_id
JOIN Movies ON Rentals.movie_id = Movies.movie_id
WHERE Movies.movie_title = $1

--Movie rental director query
SELECT Customers.customer_fname, Customers.customer_lname, Rentals.rentals_rentdate, Movies.movie_title
FROM Rentals
JOIN Customers ON Rentals.customer_id = Customers.customer_id
JOIN Movies ON Rentals.movie_id = Movies.movie_id
WHERE Movies.movie_director = $1

--Null value query
SELECT Movies.movie_title, Rentals.rentals_rentdate, Customers.customer_fname, Customers.customer_lname
FROM Rentals
JOIN Customers ON Rentals.customer_id = Customers.customer_id
JOIN Movies ON Rentals.movie_id = Movies.movie_id
WHERE Rentals.rentals_returndate IS NULL