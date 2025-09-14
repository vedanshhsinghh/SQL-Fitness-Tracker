create database fitness_tracker;

use fitness_tracker;

#USERS TABLE
create table users(
user_id int primary key auto_increment,
name varchar (50),
age int,
gender enum('MALE', 'FEMLALE', 'OTHER'),
weight float,
height float
);

#WORKOUTS TABLE
create table workouts(
workout_id int primary key auto_increment,
user_id int, 
exercise varchar(50),
duration int, #in minutes
calories_burned float, 
workout_date date,
foreign key(user_id) references users(user_id)
);

ALTER TABLE Users MODIFY COLUMN gender ENUM('Male', 'Female', 'Other', 'Non-Binary') NOT NULL;

INSERT INTO users (name, age, gender, weight, height) VALUES 
('Vedansh', 19, 'Male', 70, 1.75),
('Amit', 22, 'Male', 80, 1.80),
('Sara', 25, 'Female', 65, 1.68),
('Rahul', 21, 'Male', 75, 1.78),
('Priya', 24, 'Female', 60, 1.62),
('Arjun', 27, 'Male', 85, 1.82),
('Neha', 23, 'Female', 58, 1.65),
('Rohit', 26, 'Male', 90, 1.85),
('Pooja', 20, 'Female', 55, 1.60),
('Vikram', 28, 'Male', 78, 1.77);

insert into workouts (user_id, exercise, duration, calories_burned, workout_date) VALUES 
(1, 'Running', 30, 300, '2025-03-01'),
(1, 'Cycling', 45, 400, '2025-03-02'),
(2, 'Weightlifting', 60, 250, '2025-03-02'),
(2, 'Swimming', 40, 350, '2025-03-03'),
(3, 'Yoga', 40, 150, '2025-03-03'),
(3, 'Running', 35, 320, '2025-03-04'),
(4, 'Jump Rope', 20, 200, '2025-03-04'),
(4, 'Cycling', 50, 450, '2025-03-05'),
(5, 'Pilates', 45, 180, '2025-03-05'),
(5, 'Swimming', 50, 400, '2025-03-06'),
(6, 'Weightlifting', 60, 270, '2025-03-06'),
(6, 'Treadmill', 30, 290, '2025-03-07'),
(7, 'Yoga', 50, 160, '2025-03-07'),
(7, 'Jump Rope', 25, 210, '2025-03-08'),
(8, 'Running', 40, 350, '2025-03-08'),
(8, 'Cycling', 60, 480, '2025-03-09'),
(9, 'Pilates', 50, 190, '2025-03-09'),
(9, 'Weightlifting', 55, 260, '2025-03-10'),
(10, 'Treadmill', 35, 310, '2025-03-10'),
(10, 'Swimming', 45, 370, '2025-03-11');

#get all workouts for a specified user 
select * 
from workouts where user_id = 5;

#find total calories burned by each user
select u.name, sum(w.calories_burned) as total_calories_burned
from users u
join workouts w 
on u.user_id = w.user_id
group by u.name
order by total_calories_burned desc;

#find the most common workout type
select exercise, count(*) as times_done
from workouts 
group by exercise 
order by times_done desc;

#find workouts in the last 7 days 
select *
from workouts where workout_date >= curdate() - interval 7 day;

#rank users based on total calories burned 
select u.name, sum(w.calories_burned) as total_calories_burned, 
rank() over (order by sum(w.calories_burned) desc) as ranks
from users u
join workouts w 
on u.user_id = w.user_id
group by u.name;

#create view (user workout summary)
create view User_workout_summary as 
select u.name, count(w.workout_id) as total_workouts, 
sum(w.calories_burned) as total_calories 
from users u
join workouts w 
on u.user_id = w.user_id
group by u.name; 

select * from  user_workout_summary;

#stored procedure (get user workout summary)
delimiter //
create procedure GETUSERWORKOUTSUMMARY (in userid int)
begin
	select u.name, count(w.workout_id) as total_workouts,
    sum(w.calories_burned) as total_calories
    from users u 
    join workouts w 
    on u.user_id = w.user_id
    group by u.name;
end //
delimiter ; 


