--music dataset
--Which employee is the most senior based on their job title?

select * from employee
order by levels desc
limit 1;

--Which countries have generated the highest number of invoices?
select * from invoice
select count (*) as count_invoices, billing_country
from invoice 
group by billing_country
order by count_invoices desc

--What are the top three highest values of total invoice amounts?
select * from invoice
order by total desc
limit 3;

--Which city has the best customers?
--We plan to organize a promotional music festival in the city where we earned the highest revenue.
--Write a query that returns one city with the highest total sum of invoice amounts.

select sum(total) as invoice_total,billing_city
from invoice
group by billing_city
order by invoice_total desc

--Who is the best customer?
--The best customer is defined as the one who has spent the most money overall.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(i.total) AS total_amount
FROM customer c
JOIN invoice i 
    ON c.customer_id = i.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY 
    total_amount DESC
LIMIT 1;

--Write an SQL query to retrieve the email, first name, last name, and genre of all customers who listen to Rock music.
--The results should be sorted alphabetically by email, starting from A.

SELECT DISTINCT
    c.email,
    c.first_name,
    c.last_name,
    g.name AS genre
FROM customer c
JOIN invoice i 
    ON c.customer_id = i.customer_id
JOIN invoice_line il 
    ON i.invoice_id = il.invoice_id
JOIN track t 
    ON il.track_id = t.track_id
JOIN genre g 
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;


--Identify the artists who have created the highest number of Rock tracks in the dataset.
--Write an SQL query that returns the artist name along with the total number of Rock tracks for the top 10 Rock bands.

SELECT 
    ar.artist_id,
    ar.name,
    COUNT(*) AS number_of_songs
FROM track t
JOIN album al ON al.album_id = t.album_id
JOIN artist ar ON ar.artist_id = al.artist_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY number_of_songs DESC
LIMIT 10;

--Retrieve the names of all tracks whose duration is longer than the average song length.
--Return each track’s Name and Milliseconds, and sort the results by song length in descending order (longest songs first).

SELECT 
    name,
    milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY milliseconds DESC;

--Calculate the total amount spent by each customer on each artist. 
--Write a query that returns the customer name, artist name, and total amount spent.

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--Determine the most popular music genre for each country. 
--The most popular genre is defined as the genre with the highest number of purchases.
--Write a query that returns each country along with its top genre. If multiple genres share the highest number of purchases in a country, return all tied genres.

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1


--Identify the customer who has spent the most on music in each country.
-- Write a query that returns the country, the top customer, and the total amount spent. 
--If multiple customers are tied for the highest spending in a country, return all such customers.

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1


