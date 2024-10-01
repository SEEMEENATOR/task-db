select 
a.aircraft_code,
s.fare_conditions,
count(s.seat_no) as seat_count
from bookings.aircrafts a
join bookings.seats s on a.aircraft_code = s.aircraft_code
GROUP BY a.aircraft_code, s.fare_conditions
ORDER BY a.aircraft_code, s.fare_conditions;
   
select a.aircraft_code, a.model, count(s.seat_no) as seat_count
from bookings.aircrafts a
join bookings.seats s on a.aircraft_code = s.aircraft_code
group by a.aircraft_code, a.model
order by seat_count desc
limit 3;

select flight_id,flight_no,scheduled_departure,actual_departure,status 
from bookings.flights
where actual_departure is not null and (actual_departure-scheduled_departure) > interval '2 hours';

select t.ticket_no, t.passenger_name, t.contact_data, tf.fare_conditions 
from bookings.tickets t
join bookings.ticket_flights tf on t.ticket_no = tf.ticket_no 
join bookings.bookings b on t.book_ref = b.book_ref 
where fare_conditions like 'Business'
order by b.book_date desc
limit 10

select f.* from bookings.flights f 
left join bookings.ticket_flights tf on f.flight_id  = tf.flight_id 
and tf.fare_conditions = 'Business'
where tf.ticket_no is null;

select a.airport_name, a.city from bookings.airports a
join bookings.flights f on f.departure_airport  = a.airport_code 
where f.status = 'Delayed'

select a.airport_name, count(f.flight_id) as flight_count from bookings.airports a
join bookings.flights f on f.departure_airport  = a.airport_code
group by a.airport_name 
order by flight_count desc;

select * from bookings.flights f
where actual_arrival is not null  and
f.actual_arrival != f.scheduled_arrival

select a.aircraft_code, a.model, s.seat_no from bookings.aircrafts a 
join bookings.seats s on a.aircraft_code = s.aircraft_code 
where a.model = 'Аэробус A321-200' and s.fare_conditions != 'Economy'
order by s.seat_no;

select a.airport_code, a.airport_name, a.city from bookings.airports a 
where a.city in (
select city from bookings.airports
group by city
having count(*) > 1
);

select t.passenger_id, t.passenger_name, SUM(b.total_amount) AS total_booking_amount
from bookings.tickets t
join bookings.bookings b ON t.book_ref = b.book_ref
group by t.passenger_id, t.passenger_name
having sum(b.total_amount) > (SELECT avg(total_amount) FROM bookings.bookings);

select f.flight_no, f.scheduled_departure_local, f.scheduled_arrival_local, f.status, f.departure_airport_name, f.arrival_airport_name
from bookings.flights_v f
where f.departure_city = 'Екатеринбург'
and f.arrival_city = 'Москва'
and f.scheduled_departure > bookings.now() 
and f.status IN ('Scheduled', 'On Time', 'Delayed') 
order by f.scheduled_departure
limit 1; 

select min(amount) AS cheapest_ticket_price, max(amount) AS most_expensive_ticket_price
from bookings.ticket_flights;

create table Customers (
id SERIAL primary key,
firstName varchar(50) not null,
lastName varchar(50) not null,
email varchar(100) unique not null,
phone varchar(50),
constraint email_format check (email like '%_@__%.__%')
);


create table Orders (
id SERIAL primary key,
customerId INT not null,
quantity INT check (quantity > 0),
constraint fk_customers
foreign key (customerId)
references Customers(id)
on delete cascade
);

insert into Customers (firstName, lastName, email, phone)
values
('Maksim', 'Khimiak', 'maks@gmail.com', '+375-29-123-23-32'),
('Ruslan', 'Frolov', 'rusik@gmail.com', '+375-43-43-53-72'),
('Maksim', 'Rudakov', 'maksRud@gmail.com', '+7-938-302-24-62'),
('Dmitry', 'Molchanov', 'dmmolch@yandex.ru', '+375-22-167-11-22'),
('Alena', 'Kyzmina', 'Ala@mail.ru', '+7-925-333-22-12');

select * from Customers;

insert into Orders (customerId, quantity)
values
(1,10),
(2,5),
(3,1),
(4,8),
(5,15);

select * from Orders;

