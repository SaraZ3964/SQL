Use sakila ;

-- 1a: Display the first and last names of all actors from the table actor.
select first_name
,last_name
from actor;

-- 1b: Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select 
concat(first_name, ' '  ,last_name) as 'Actor Name'
from actor;

-- 2a: You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id,
first_name,
last_name
-- ID number, first name, and last name
from actor
where first_name = 'JOE';

-- 2b: Find all actors whose last name contain the letters GEN
select actor_id,
first_name,
last_name
from actor
where last_name like '%GEN%';

-- 2c: Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order.
select actor_id,
first_name,
last_name
from actor
where last_name like '%LI%' 
order by last_name, first_name;

-- 2d: Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China.
select country_id,
country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a: You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description blob AFTER last_update;
set max_sort_length = 2000;

-- 3b: Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP description;

--  4a: List the last names of actors, as well as how many actors have that last name.
select last_name
,count(last_name) as 'Count'
from actor
group by last_name;

-- 4b: List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name,
count(last_name) as 'Count'
from actor
group by last_name
having count(last_name) >=2;

-- 4c: The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d: Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
SET SQL_SAFE_UPDATES = 0;
update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO' and actor_id = '172';

-- 5a: You cannot locate the schema of the address table. Which query would you use to re-create it?
/* SHOW CREATE TABLE sakila.address;
create table address (address_id INT AUTO_INCREMENT NOT NULL,
address varchar(100) not null,
address2 varchar(100) DEFAULT NULL,
district varchar(50) not null,
city_id smallint(5) unsigned not null,
postal_code int(5) DEFAULT NULL,
phone int(13) not null,
location geometry not null,
last_udpate timestamp not null default current_timestamp on update current_timestamp,
primary key (address_id)
) engine = innoDB default charset = utf8; */

-- 6a:  Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address.
select first_name,
last_name,
address
from staff
join address
on staff.address_id = address.address_id;

-- 6b: Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select staff.staff_id
,staff.first_name
,staff.last_name
,sum(payment.amount) as total_amount
from staff
join payment
on staff.staff_id = payment.staff_id
where payment.payment_Date between '2005-08-01' and '2005-08-31'
group by staff.staff_id;

-- 6c: List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select film.title
, count(film_actor.film_id) as 'Num of actors'
from film
inner join film_actor
on film.film_id = film_actor.film_id
group by film.title;

-- 6d: How many copies of the film Hunchback Impossible exist in the inventory system?
select film.title,
count(inventory.film_id) as 'Num of film'
from inventory
join film
on inventory.film_id = film.film_id
where film.title = 'Hunchback Impossible';

-- 6e: Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
select c.first_name
, c.last_name
, sum(p.amount) as 'Total Amount Paid'
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id
order by c.first_name, c.last_name;

-- 7a:  The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title
from film f
join language l
on f.language_id = l.language_id
where  f.title like 'K%' or f.title like 'Q%'
and f.language_id = '1';

-- 7b: Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name,
a.last_name
from actor a
join film_actor fa
on fa.actor_id = a.actor_id
join film f
on f.film_id = fa.film_id
where f.title = 'Alone Trip';

-- 7c: You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select c.first_name,
c.last_name,
c.email
from customer c
join address a
on a.address_id = c.address_id
join city 
on city.city_id = a.city_id
join country
on country.country_id = city.country_id
where country.country = 'Canada'; 

-- 7d: Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title, category
FROM film_list
WHERE category = 'Family';

-- 7e: Display the most frequently rented movies in descending order.
select f.title,
count(r.rental_id) as 'frequency of rental'
from film f
join inventory i
on f.film_id = i.film_id
join rental r
on r.inventory_id = i.inventory_id
group by f.title
order by count(r.rental_id) desc ;

-- 7f: Write a query to display how much business, in dollars, each store brought in.
select s.store_id,
concat('$', format(sum(p.amount), 2)) as 'Amount'
from store s
inner join  customer c
on c.store_id = s.store_id
inner join payment p
on p.customer_id = c.customer_id
group by s.store_id;

-- 7g: Write a query to display for each store its store ID, city, and country.
select s.store_id,
city.city,
c.country
from store s
join address a
on a.address_id = s.address_id
join city
on city.city_id = a.city_id
join country c
on c.country_id = city.country_id;

-- 7h: List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: 
-- category, film_category, inventory, payment, and rental.)
select c.name
,sum(p.amount) as Amount
from category c
join film_category f
on c.category_id = f.category_id
join inventory i
on i.film_id = f.film_id
join rental r
on r.inventory_id = i.inventory_id
join payment p 
on p.customer_id = r.customer_id
group by c.name
order by sum(p.amount) desc
limit 5;

-- 8a： In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view the_top_five_genres_in_gross_revenue as 

select c.name
,sum(p.amount) as Amount
from category c
join film_category f
on c.category_id = f.category_id
join inventory i
on i.film_id = f.film_id
join rental r
on r.inventory_id = i.inventory_id
join payment p 
on p.customer_id = r.customer_id
group by c.name
order by sum(p.amount) desc
limit 5;

-- 8b: How would you display the view that you created in 8a?
select *
from the_top_five_genres_in_gross_revenue;

-- 8c: You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view the_top_five_genres_in_gross_revenue

