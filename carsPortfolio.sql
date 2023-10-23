-- EDA
	-- We have a Dataset containing information on cars
	-- The different colums are 
		-- Price , Mileage, Make, Model, Trim, Type, Cylinder (number of)
		-- Liter (engine size), Doors (2 or 4) and Cruise control, Leather seats and Sound System ( 1 or 0 for all 3) 

--lets view the dataset and see what it looks like
select *
from PortfolioProjects..cars
order by Price desc
	--804 records and 12 fields


--1) Basic Descriptive Stats for numeric columns
select
	avg(price) as avgprice --21.34k
	, min(price) as minprice --8.63k
	, max(price) as maxprice --70.75k
	, avg(mileage) as avgmileage --19.83k
	, min(mileage) as minmileage --266
	, max(mileage) as maxmileage --50.38k
from PortfolioProjects..cars

--2) Count of cars with Cruise control(605), sound(546) and Leather(582) seats 
select
	sum(cruise) as cars_with_cruise
	, sum(sound) as cars_with_sound
	, sum(leather) as cars_with_leather
from PortfolioProjects..cars

--3) Lets get the Average price by make and model
select
	make
	, model
	, avg(price) as avg_price
from PortfolioProjects..cars
group by make, model
order by avg_price desc

--Lets Filter the data even more

--4) Lets get the Average price of cars with leather seats and cruise control
	-- 25.22k
select avg(price) as avg_price
from PortfolioProjects..cars
where leather = 1 and cruise = 1

--5) Distribution of car types
select
	type
	, count(*) as count
from PortfolioProjects..cars
group by type

--6) Most common trim
select
	trim
	, count(*) as count
from PortfolioProjects..cars
group by trim
order by count desc

--7a) Segment cars into price ranges (Budget, Mid-Range and Luxury)
select
	case
		when Price <= 10000 then 'Budget' -- 15
		when Price > 10000 and Price < 30000 then 'Mid-Range' -- 639
		when Price >= 30000 then 'Luxury' -- 150
	end as price_range
	, count(*) as car_count
from PortfolioProjects..cars
group by
	case
		when Price <= 10000 then 'Budget'
		when Price > 10000 and Price < 30000 then 'Mid-Range'
		when Price >= 30000 then 'Luxury'
	end

--7b) Simliar to 7a but segmeted into their different types as well 
select type,
	case
		when Price <= 10000 then 'Budget' -- 15
		when Price > 10000 and Price < 30000 then 'Mid-Range' -- 639
		when Price >= 30000 then 'Luxury' -- 150
	end as price_range
	, count(*) as car_count
from PortfolioProjects..cars
group by type,
	case
		when Price <= 10000 then 'Budget'
		when Price > 10000 and Price < 30000 then 'Mid-Range'
		when Price >= 30000 then 'Luxury'
	end
order by car_count desc

--8a) Price (number of cars at each price point)
select
	Price
	, count(*) as car_count
from PortfolioProjects..cars
group by Price
order by Price

--9) Relationship btw Number of Doors and Average price
select
	Doors
	, AVG(Price) as avg_price
from PortfolioProjects..cars
group by Doors
	-- We see that on average 2 door cars are more expensive by almost 4k comopared to the 4 door counterparts
	-- number of doors is inversely prop to avg price

--10) Lets look into the different features (leather, sound, cruise)
select
	case
		when Cruise = 1 then 'Cruise Control'
 		when Sound = 1 then 'Sound System'
		when Leather = 1 then 'Leather seats'
	end as features
	, avg(Price) as avg_price
from PortfolioProjects..cars
group by
	case
		when Cruise = 1 then 'Cruise Control'
 		when Sound = 1 then 'Sound System'
		when Leather = 1 then 'Leather seats'
	end
order by avg_price desc

	-- avg price for cars with Cruise Control is 23.78k
	-- avg price for cars with Sound System is 14.21k
	-- avg price for cars with Leather Seats is 13.17k
	-- avg price for cars without the above is 12.93k

--11) Analysis of Cylinders and Engine Size (Liter):
	--To understand how the number of cylinders and engine size (liter) relate to car prices:
select
	Cylinder
	, Liter
	, avg(Price) as avg_price
from PortfolioProjects..cars
group by Cylinder, Liter

--12) Type and Trim Level Analysis:
	--Examine the distribution of car types within each trim level:
select 
	type
	, Trim
	, count(*) as car_count
from PortfolioProjects..cars
group by type, Trim

select
	type
	, count(*) as car_count
from PortfolioProjects..cars
group by type
	--50 Convertible 140 Coupe 60 Hatchback 
	--490 Sedan 64 Wagon

--13) Outlier analysis
	-- we want to know info on vehicles atleast 2 Standard deviations away from the average price (21.34k)
select
	Price
	, make
	, model
from PortfolioProjects..cars
	where Price > (select avg(Price) + 2*STDEV(Price) from PortfolioProjects..cars)
order by Price
	-- we see that there are 35 vehicles here (all luxury ie > 30k)
