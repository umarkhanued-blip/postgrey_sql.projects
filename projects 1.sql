-- use database;
-- only works on my sql
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
-- open book data
copy books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
from 'C:\Users\Public\files_for_project\Books.csv'
csv header;
-- open customers data 
copy customers(Customer_ID,Name,Email,Phone,City,Country
)
from 'C:\Users\Public\files_for_project\Customers.csv'
csv header;
-- open orders data
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
copy orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount
)
from 'C:\Users\Public\files_for_project\Orders.csv'
csv header;
-- retrieve all books in the  fiction genre
select * from books where genre='Fiction'
-- find books publish after year 1950
select * from books where published_year>1950
-- list all customers whose belong to canada 
select * from customers where country in('Canada','canada')
-- shows order placed in november 2023
select * from orders where order_date between'2023-11-1' and '2023-11-30' order by order_date asc;
-- retrieve total stock of a book avalilabe
select sum(stock) as total_stock from books
-- find detail for the most expensive books
select * from books where price=(select max(price) from books)
select * from books order by price desc limit 1;
-- show customers who ordered more than one quantity of a book in orders data 
select *from orders where quantity>1
-- order table se jis user ki quantity 1 se zyda ho tou customer table ka pura data print ko iss ke ilawa order table se date bhi ayee 
 SELECT 
    customers.*, 
    orders.order_date,
    orders.quantity -- Yahan 's' lagana zaroori hai
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
WHERE orders.quantity > 1;
-- inner joints
SELECT * 
FROM customers.*,orders.order_id,orders.order_date,orders.quantity
INNER JOIN orders ON customers.customer_id = orders.customer_id;
show customers and orders who ordered more than one quantity
-- select data on customer table and orders table based on there id depends on if quatity greater than one
SELECT * 
FROM customers
INNER JOIN orders 
ON customers.customer_id = orders.customer_id 
WHERE orders.quantity > 1;
-- problem hai iss code se duplicate column customer id bhi ayeegi solution using ka use 
SELECT * 
FROM customers
INNER JOIN orders 
using (customer_id)
WHERE orders.quantity>1;

-- retrieve all orders where the total amount exceed a 20$
select * from orders where total_amount>20
-- list all genre avalilabe in a book table
select genre from 
-- find books with lowest stock
select * from books where stock=(select min(stock) from books)
select title,author,price,stock from books where stock=(select min(stock) from books)
-- calculate total revenue generated from all orders

select cast(sum(total_amount) as int) as total_revnue from orders
-- SOME ADVANCE QUESTIONS:
-- retrieve total number of book sold by each genre
SELECT b.genre, SUM(o.quantity) AS sold_based_on_genre 
FROM orders o  
JOIN books b ON o.book_id = b.book_id 
GROUP BY b.genre;
-- find the average price of books in the fantasy genre
-- 2) Find the average price of books in the "Fantasy" genre.
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';
-- 3)list customers who has placed at lesed two orders
select  customer_id,count(order_id) as customers_orders from orders
group by customer_id having count(order_id)>=2 order by customer_id asc;
-- find the most frequently orderecd book and there data instead
select b.book_id,b.title,count(o.order_id) as order_count from orders o join books b on b.book_id=o.book_id group by b.book_id,b.title order by order_count desc 
-- show top three most expensive book of fantasy genre

select * from books where genre='Fantasy' order by price desc limit 3
-- Retrieve the total quantity of book sold by each auther
-- har auther ki kitne book bikke hain 
SELECT b.author, SUM(o.quantity) AS author_sold_book_quantity 
FROM books b 
JOIN orders o ON b.book_id = o.book_id 
GROUP BY b.author 
ORDER BY author_sold_book_quantity desc limit 5;
-- list the cities where customer spends more than 30$ are located
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;
-- Q:[dnt_know] find customer whose spend most on orders.
-- group by on customer_name
-- it use quantity and total amount 8*188.56=1,508.48 as order_bill based on customer unique name name is umar sum(all_order_bill
SELECT 
    c.customer_id,
    c.name, -- Table ke mutabiq customer_name likhna hai
    SUM(o.total_amount) AS customer_total_spend 
	-- with formula if total amount exists (sum(o.quantity*b.price) as customer_total_spend)
FROM 
    orders o  
JOIN 
    customers c ON o.customer_id = c.customer_id  
JOIN 
    books b ON o.book_id = b.book_id  
GROUP BY 
    c.customer_id,
    c.name 
ORDER BY 
    customer_total_spend DESC 
LIMIT 3;
-- order central table connected to both book and customer table 
select * from books;
select * from customers;
select * from orders;
-- calculate stock remainning after fullfilling all orders 

SELECT
    b.book_id,
    b.price,
    b.stock,
    (b.stock - COALESCE(SUM(o.quantity), 0)) AS remaining_book_stock
FROM books b 
JOIN 
    orders o ON b.book_id = o.book_id 
GROUP BY 
    b.book_id,
    b.price,
    b.stock
ORDER BY b.book_id ASC;
