select * from album 

Q.1

select * from employee 
order by levels desc 
limit 1


Q.2
select count(*) as count , billing_country 
from invoice 
group by billing_country 
order by count desc 

Q.3

SELECT SUM(TOTAL) AS TOP_3_invoice, billing_city 
FROM INVOICE group by billing_city LIMIT 3 


Q.4

SELECT SUM(TOTAL) AS T, BILLING_CITY 
FROM INVOICE GROUP BY BILLING_CITY 
ORDER BY T DESC LIMIT 1 


Q.5 

SELECT C.FIRST_NAME, C.LAST_NAME, C.customer_id, 
SUM(TOTAL) AS T_PURCHASE
FROM CUSTOMER C 
JOIN INVOICE I 
ON C.CUSTOMER_ID = I.CUSTOMER_ID 
GROUP BY C.customer_id
ORDER BY T_PURCHASE DESC LIMIT 1 

Q.2.1 

select distinct email, first_name, last_name 
from customer 
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
                   select track_id from track 
                   join genre on track.genre_id = genre.genre_id
                   where genre.name like 'Rock')
order by email				   

				 
Q.2.2  


select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id 
order by number_of_songs desc
limit 10 ;

Q.2.3 

select name, milliseconds
from track 
where milliseconds > (select avg(milliseconds) as 
					 avg_track_length 
					 from track )
order by milliseconds desc					 

				 
Q.3.1  
with best_selling_artist as (
select artist.artist_id as artist_id, artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales	
from invoice_line 
join track on  track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by 1 
order by 3 desc 
limit 1 
)

select c.customer_id,c.first_name,c.last_name, bsa.artist_name,
sum (il.unit_price*il.quantity) as amount_spent 
from invoice i
join customer c on c.customer_id= i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc ;

Q.3.2 
with popular_genre as 
(
select count(invoice_line.quantity) as purchase , genre.name, genre.genre_id, customer.country,
ROW_NUMBER() over(partition by customer.country order by count(invoice_line.quantity)desc ) as rowno
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track	on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4
order by customer.country asc , 1 desc
)

select * from popular_genre where rowno <= 1

Q.3.3

with recursive customer_with_country as (
select customer.customer_id, customer.first_name,customer.last_name, 
billing_country, sum(total) as total_spending
from invoice
join customer on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 2,3 desc),

country_max_spending as (
	select billing_country, max(total_spending) as max_spending
from customer_with_country 
group by billing_country)	
 
select cc.billing_country, cc.total_spending, cc.first_name ,cc.last_name, cc.customer_id
from customer_with_country cc
join country_max_spending ms
on cc.billing_country = ms.billing_country 
where cc.total_spending = ms.max_spending
order by 1;


other_method 

with customer_with_country as (
	select customer.customer_id,first_name,last_name,
	billing_country,sum(total) as total_spending,
	row_number() over(partition by billing_country order by
					 sum(total) desc) as rowno
	from invoice
	join customer on customer.customer_id= invoice.customer_id
	group by 1,2,3,4
	order by 4 asc, 5 desc)
	select * from customer_with_country where rowno<=1
























