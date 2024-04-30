-- 			MY_SQL_ASSIGNMENT-2 --

-- Question 1:
-- Retrieve the total number of rentals made in the Sakila database.
use mavenmovies;
select * from rental;
select count(*) from rental;-- 16044

-- Question 2:
-- Find the average rental duration of movies rented from the Sakila database.
select * from film;
select avg(rental_duration) from film;

-- Question 3:
-- Display the first name and last name of customers in uppercase.
select upper(first_name), upper(last_name) from customer;

-- Question 4:
-- Extract the month from the rental date and display it alongside the rental ID.
select * from rental;
select rental_id, month(rental_date),monthname(rental_date) from rental;

-- Question 5:
-- Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
select * from rental;
select customer_id, count(rental_id) from rental group by customer_id;

-- Question 6:
-- Find the total revenue generated by each store.
select * from store;
select* from payment;
SELECT 
    store_id, SUM(amount)
FROM
    payment p
        INNER JOIN
    store s ON p.staff_id = s.manager_staff_id
GROUP BY store_id;

-- Question 7:
-- Display the title of the movie, customer's first name, and last name who rented it.
select * from film; -- film_id, title
select * from customer; -- customer_id and name
select * from rental; -- customer_id, inventory_id
select * from inventory; -- film_id, inventory_id
SELECT 
    title, first_name, last_name
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
        INNER JOIN
    inventory i ON r.inventory_id = i.inventory_id
        INNER JOIN
    film f ON i.film_id = f.film_id;

-- Question 8:
-- Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
select * from actor; -- actor_id
select * from film_actor; -- actor_id, film_id
select * from film; -- film_id
SELECT 
    CONCAT(first_name, ' ', last_name) AS Name, title
FROM
    actor a
        INNER JOIN
    film_actor fa ON a.actor_id = fa.actor_id
        INNER JOIN
    film f ON fa.film_id = f.film_id where title = "gone trouble";
    
    select title from film where title like "gone%"; -- no title available with "gone with wind"
    

		-- Group By--
-- Question 1:
-- Determine the total number of rentals for each category of movies.
select * from rental; -- rental_id, inventory_id, customer_id, staff_id
select * from film_category; -- film_id, category_id
select * from category; -- category_id
select * from inventory; -- inventory_id, film_id, store_id

SELECT 
    c.category_id, c.name, COUNT(r.rental_id)
FROM
    category AS c
        INNER JOIN
    film_category AS fa ON c.category_id = fa.category_id
        INNER JOIN
    inventory AS i ON fa.film_id = i.film_id
        INNER JOIN
    rental AS r ON i.inventory_id = r.inventory_id
GROUP BY c.category_id;

-- Question 2:
-- Find the average rental rate of movies in each language.
select * from rental; -- rental_id, customer_id
select * from film; -- film_id, language_id
select * from language; -- language_id
select l.language_id, avg(rental_rate) from language as l
left join film as f on l.language_id= f.language_id group by l.language_id;


		-- Joins-- 
-- Question 3:
-- Retrieve the customer names along with the total amount they've spent on rentals.
select * from customer; -- customer_name, customer_id
select * from payment; -- customer_id, amount
SELECT 
    first_name, last_name, SUM(amount) AS amount_spent
FROM
    customer AS c
        INNER JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id; 

-- Question 4:
-- List the titles of movies rented by each customer in a particular city (e.g., 'London').
select * from film; -- title, film_id
select * from city; -- city, city_id
select * from customer; -- name, customer_id, address_id
select * from rental; -- customer_id, rental_id, inventory_id, staff_id
select * from inventory;-- film_id, inventory_id
select * from address; -- city_id, address_id
SELECT 
    c.first_name, c.last_name, ct.city
FROM
    film AS f
        INNER JOIN
    inventory AS i ON f.film_id = i.film_id
        INNER JOIN
    rental AS r ON i.inventory_id = r.inventory_id
        INNER JOIN
    customer AS c ON r.customer_id = c.customer_id
        INNER JOIN
    address AS a ON c.address_id = a.address_id
        INNER JOIN
    city AS ct ON a.city_id = ct.city_id
GROUP BY c.first_name , c.last_name , ct.city
HAVING COUNT(DISTINCT ct.city);
	
		-- Advanced Joins and Group by--
-- Question 5:
-- Display the top 5 rented movies along with the number of times they've been rented.
select * from film; -- film_id
select * from rental; -- rental_id, inventory_id
select * from inventory; -- film_id, inventory_id
SELECT 
    f.title, COUNT(rental_duration)
FROM
    film AS f
        INNER JOIN
    inventory AS i ON f.film_id = i.film_id
        INNER JOIN
    rental AS r ON i.inventory_id = r.inventory_id
GROUP BY title
LIMIT 5;

-- Question 6:
-- Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
select * from customer;-- customer_id, store_id, name
select * from inventory; -- inventory_id, film_id, store_id
select * from rental; -- rental_id, inventory_id, staff_id
select * from store; -- store_id, manager_staff_id

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name
FROM
    customer AS c
        INNER JOIN
    inventory AS i ON c.store_id = i.store_id
        INNER JOIN
    rental AS r ON i.inventory_id = r.inventory_id
        INNER JOIN
    store AS s ON r.staff_id = s.manager_staff_id
WHERE
    s.store_id IN (1 , 2)
GROUP BY c.customer_id , name;