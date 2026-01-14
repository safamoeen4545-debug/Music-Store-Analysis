# SQL_Project_Music_Store_Analysis
![download](https://github.com/user-attachments/assets/d3f0e39a-f947-4db8-997e-abca582b1ad8)

## Overview

**This project involves a comprehensive SQL-based analysis of a Music Store database.
**The goal is to extract meaningful business insights related to customers, sales, music genres, artists, and geographic performance.

**This README provides a detailed account of the project objectives, business problems, SQL solutions, key findings, and conclusions, making it suitable for portfolio and data analyst roles.

##🎯 Objectives

Identify top-performing employees and customers

Analyze sales and revenue distribution across countries and cities

Understand customer music preferences by genre and artist

Discover popular genres and high-spending customers per country

Practice SQL concepts including joins, aggregations, subqueries, CTEs, and window functions

##🗂️ Dataset

The dataset represents a digital music store and includes customer purchases, invoices, tracks, albums, artists, and genres.

Key Tables Used

employee

customer

invoice

invoice_line

track

album

artist

genre

## 🧱 Schema (Simplified)
employee(employee_id, first_name, last_name, title, levels)
customer(customer_id, first_name, last_name, email, country)
invoice(invoice_id, customer_id, billing_city, billing_country, total)
invoice_line(invoice_line_id, invoice_id, track_id, unit_price, quantity)
track(track_id, name, album_id, genre_id, milliseconds)
album(album_id, artist_id)
artist(artist_id, name)
genre(genre_id, name)

##📊 Business Problems and Solutions
### 1. Who is the senior most employee based on job title?

```sql
SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;
```


## Objective: Identify the most senior employee in the organization.

### 2. Which countries have the most invoices?

```sql
SELECT billing_country, COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;
```

##Objective: Analyze customer distribution by country.

#### 3. What are the top 3 invoice totals?
```sql
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;
```


## Objective: Identify the highest-value invoices.

### 4. Which city has generated the highest revenue?
```sql
SELECT billing_city, SUM(total) AS invoice_total
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1;
```


## Objective: Find the city with the best customers based on total spending.

### 5. Who is the best customer overall?
```sql
SELECT customer.customer_id, customer.first_name, customer.last_name,
SUM(invoice.total) AS total_spent
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spent DESC
LIMIT 1;
```


## Objective: Identify the highest-spending customer.

### 6. List all Rock music listeners.
```sql
SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock'
ORDER BY email;
```


## Objective: Identify customers who prefer Rock music.

#### 7. Find the top 10 rock artists by number of tracks.

```sql
SELECT artist.name, COUNT(track.track_id) AS number_of_songs
FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON album.album_id = track.album_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock'
GROUP BY artist.name
ORDER BY number_of_songs DESC
LIMIT 10;
```

## Objective: Discover the most productive Rock artists.

#### 8. Find tracks longer than the average song length.

```sql
SELECT name, milliseconds
FROM track
WHERE milliseconds >
(
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY milliseconds DESC;
```


## Objective: Identify unusually long tracks.

### 9. Find how much each customer spent on each artist.

```sql
SELECT customer.first_name, customer.last_name, artist.name,
SUM(invoice_line.unit_price * invoice_line.quantity) AS total_spent
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN album ON track.album_id = album.album_id
JOIN artist ON album.artist_id = artist.artist_id
GROUP BY customer.first_name, customer.last_name, artist.name
ORDER BY total_spent DESC;
```


## Objective: Analyze customer spending patterns by artist.

### 10. Find the most popular music genre for each country.
```sql

WITH popular_genre AS (
    SELECT COUNT(invoice_line.quantity) AS purchases,
           customer.country,
           genre.name,
           ROW_NUMBER() OVER(
               PARTITION BY customer.country
               ORDER BY COUNT(invoice_line.quantity) DESC
           ) AS row_no
    FROM invoice_line
    JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN customer ON customer.customer_id = invoice.customer_id
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN genre ON genre.genre_id = track.genre_id
    GROUP BY customer.country, genre.name
)
SELECT country, name, purchases
FROM popular_genre
WHERE row_no = 1;
```

## Objective: Identify country-wise music preferences.

### 11. Find the top-spending customer for each country.

```sql
WITH customer_with_country AS (
    SELECT customer.customer_id,
           first_name,
           last_name,
           billing_country,
           SUM(total) AS total_spent,
           ROW_NUMBER() OVER(
               PARTITION BY billing_country
               ORDER BY SUM(total) DESC
           ) AS row_no
    FROM invoice
    JOIN customer ON customer.customer_id = invoice.customer_id
    GROUP BY customer.customer_id, first_name, last_name, billing_country
)
SELECT *
FROM customer_with_country
WHERE row_no = 1;

```
## Objective: Identify high-value customers in each country.

### 📈 Findings and Conclusion

##Certain cities and countries contribute significantly more to total revenue

Rock music is one of the most popular genres across customers

A small group of customers accounts for a large portion of sales

Advanced SQL techniques help uncover deep business insights

This project demonstrates real-world SQL analysis skills applicable to data analyst and business intelligence roles.

## 👤 Author

Safa Moeen
This project is part of my data analytics portfolio, showcasing practical SQL skills.

If you have feedback, questions, or collaboration ideas, feel free to connect!

##. 🌐 Stay Connected

## LinkedIn: www.linkedin.com/in/safa-moeen-90b7bb261

Thank you for checking out this project! ⭐
If you found it useful, consider giving the repository a star.
Schema- Music Store Database  
![MusicDatabaseSchema](https://user-images.githubusercontent.com/112153548/213707717-bfc9f479-52d9-407b-99e1-e94db7ae10a3.png)
