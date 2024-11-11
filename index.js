const { Pool } = require('pg');

//PostgreSQL connection
const pool = new Pool({
  user: 'postgres', 
  host: 'localhost',
  database: 'DatabaseSprintOne', 
  password: 'PostgresPassword', 
  port: 5432,
});

//Create Movies, Customers, and Rentals tables in a step-by-step process
async function createTable() {

  //Movies
  await pool.query (`
    CREATE TABLE IF NOT EXISTS Movies (
    movie_id SERIAL PRIMARY KEY,
    movie_title VARCHAR(255) NOT NULL,
    movie_year INT,
    movie_genre VARCHAR(255),
    movie_director VARCHAR(255)
   )`
  )
  
  //Customers
  await pool.query (`
    CREATE TABLE IF NOT EXISTS Customers (
    customer_id SERIAL PRIMARY KEY,
    customer_fname VARCHAR(255),
    customer_lname VARCHAR(255),
    customer_email VARCHAR(255) UNIQUE NOT NULL,
    customer_phone TEXT
    )`
  )

  //Rentals
  await pool.query (`
    CREATE TABLE IF NOT EXISTS Rentals (
    rental_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    movie_id INT REFERENCES Movies(movie_id),
    rentals_rentdate DATE NOT NULL,
    rentals_returndate DATE,
    )`
  )
};

/**
 * Inserts a new movie into the Movies table.
 * 
 * @param {string} title Title of the movie
 * @param {number} year Year the movie was released
 * @param {string} genre Genre of the movie
 * @param {string} director Director of the movie
 */
async function insertMovie(title, year, genre, director) {
  await pool.query(
    "INSERT INTO Movies (movie_title, movie_year, movie_genre, movie_director) VALUES ($1, $2, $3, $4)",
    [title, year, genre, director]
  );
  console.log(`"${title}" has been added.`);
};

/**
 * Prints all movies in the database to the console
 */
async function displayMovies() {
  const display = await pool.query("SELECT * FROM Movies");
  console.table(display.rows);
};

/**
 * Updates a customer's email address.
 * 
 * @param {number} customerId ID of the customer
 * @param {string} newEmail New email address of the customer
 */
async function updateCustomerEmail(customerId, newEmail) {
  await pool.query(
    "UPDATE Customers SET email_address = $1 WHERE customer_id = $2", 
    [newEmail, customerId]
  );
  console.log(`${newEmail} has been set.`);
};

/**
 * Removes a customer from the database along with their rental history.
 * 
 * @param {number} customerId ID of the customer to remove
 */
async function removeCustomer(customerId) {
  await pool.query(
    "DELETE FROM Customers WHERE customer_id = $1", 
    [customerId]
  );
  console.log(`${customerId} has been deleted.`);
};

/**
 * Prints a help message to the console
 */
function printHelp() {
  console.log('Usage:');
  console.log('  insert <title> <year> <genre> <director> - Insert a movie');
  console.log('  show - Show all movies');
  console.log('  update <customer_id> <new_email> - Update a customer\'s email');
  console.log('  remove <customer_id> - Remove a customer from the database');
}

/**
 * Runs our CLI app to manage the movie rentals database
 */
async function runCLI() {
  await createTable();

  const args = process.argv.slice(2);
  switch (args[0]) {
    case 'insert':
      if (args.length !== 5) {
        printHelp();
        return;
      }
      await insertMovie(args[1], parseInt(args[2]), args[3], args[4]);
      break;
    case 'show':
      await displayMovies();
      break;
    case 'update':
      if (args.length !== 3) {
        printHelp();
        return;
      }
      await updateCustomerEmail(parseInt(args[1]), args[2]);
      break;
    case 'remove':
      if (args.length !== 2) {
        printHelp();
        return;
      }
      await removeCustomer(parseInt(args[1]));
      break;
    default:
      printHelp();
      break;
  }
};

runCLI();
