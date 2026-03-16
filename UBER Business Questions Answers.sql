/* 1. Which city generated the highest total revenue during surge pricing (where surge_multiplier > 1), 
and what was the average surge multiplier for those specific trips?*/

select 
	l.city City,
	round(avg(t.surge_multiplier),2) Avg_surge,
	round(sum(t.total_fare),2) Total_rev
from trips as t
join locations as l 
on t.pickup_location_id=l.location_id
where t.surge_multiplier > 1 and status = 'completed'
group by l.city
order by 3 desc;

/* 2. Who are the top 5 'High-Value' drivers who have an average rating above 3 and have completed more than 50 trips, 
and what is the most common vehicle make they use?*/

with TOP_Driver as (select
	d.driver_id,
	round(avg(r.rating),2) as rating,
	d.vehicle_make,
	count(t.trip_id) Total_Trips
from drivers as d
left join trips as t
on d.driver_id = t.driver_id
left join reviews as r
on r.trip_id=t.trip_id
where t.status = 'completed' and d.is_active = 1
group by 
	d.driver_id,
	d.rating ,
	d.vehicle_make)
select top 10 *
from TOP_Driver
where rating > 3 and Total_Trips>=50
order by rating desc, Total_Trips desc;

/* 3. What is the most frequent reason for cancellations initiated by 'drivers' vs 'riders*/

select 
	cancelled_by,
	reason
from (select 
	cancelled_by,
	reason,
	count(reason) ct,
ROW_NUMBER() over(partition by cancelled_by order by count(reason) desc) r
from cancellations
group by cancelled_by,reason) as abc
where r=1;




