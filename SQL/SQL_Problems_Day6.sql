 -->> Popularity Percentage
    /* Find the popularity percentage for each user on Meta/Facebook.
    The popularity percentage is defined as the total number of friends the user has divided by the
    total number of users on the platform, then converted into a percentage by multiplying by 100.
    Output each user along with their popularity percentage. Order records in ascending order by user id.
    */
select * from facebook_friends;

a) Find how many friends each user has? --
b) Find total users in FB --
c) Find PP = a / b

-- b)
select user1 from facebook_friends
union
select user2 from facebook_friends

-- a)
with all_users as
    (select user1 as users from facebook_friends
     union all
    select user2 as users from facebook_friends)
select users, count(1) as no_of_frnds
from all_users
group by users
order by 1;

-- c)
with all_users as
        (select user1 as users from facebook_friends
         union all
        select user2 as users from facebook_friends),
    user_frnds as
        (select users, count(1) as no_of_frnds
        from all_users
        group by users),
    unq_users as
        (select count(distinct users) as total_users
         from all_users)
select a.users
, round(((a.no_of_frnds::decimal / b.total_users::decimal) * 100),2) as popularity_percentage
from user_frnds a
cross join unq_users b
order by 1;




-->> User Email Labels
    /* Find the number of emails received by each user under each built-in email label.
    The email labels are: 'Promotion', 'Social', and 'Shopping'.
    Output the user along with the number of promotion, social, and shopping mails count
    */
select * from google_gmail_emails;
select * from google_gmail_labels;

select to_user --, label -- Correct solution
, sum(case when label = 'Promotion' then 1 else 0 end) as Promotion
, sum(case when label = 'Social' then 1 else 0 end) as Social
, sum(case when label = 'Shopping' then 1 else 0 end) as Shopping
from google_gmail_emails E
join google_gmail_labels L on L.email_id = E.id
where L.label in ('Promotion', 'Social', 'Shopping')
--and to_user = '5b8754928306a18b68'
group by to_user
--order by 2;


select to_user --, label
, count(case when label = 'Promotion' then 1 else 0 end) as Promotion
, count(case when label = 'Social' then 1 else 0 end) as Social
, count(case when label = 'Shopping' then 1 else 0 end) as Shopping
from google_gmail_emails E
join google_gmail_labels L on L.email_id = E.id
where L.label in ('Promotion', 'Social', 'Shopping')
and to_user = '5b8754928306a18b68'
group by to_user;


select to_user --, label
, (case when label = 'Promotion' then 1 else 0 end) as Promotion
, (case when label = 'Social' then 1 else 0 end) as Social
, (case when label = 'Shopping' then 1 else 0 end) as Shopping
from google_gmail_emails E
join google_gmail_labels L on L.email_id = E.id
where L.label in ('Promotion', 'Social', 'Shopping')
and to_user = '5b8754928306a18b68'
--group by to_user




-- WINDOW Functions
drop table employee;
create table employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);
COMMIT;


select * from employee;

-- These 11 are window functions in SQL. But some of them may not be supported in some RDBMS.
RANK
DENSE RANK
ROW_NUMBER
LAG
LEAD
NTILE
LAST_VALUE
FIRST_VALUE
NTH_VALUE
CUME_DIST
PERCENT_RANK


-- 1) Fetch the first 2 employees from each department to join the company.

select * from employee
order by dept_name, emp_id
limit 2

-- OVER clause -- can be used to create windows/partitions for your resultset

select emp_id, emp_name, dept_name
from (select *
      , row_number() over(partition by dept_name order by emp_id ) as rn
      from employee) x
where rn < 3;


select *
, row_number() over(partition by dept_name order by emp_id ) as rn
from employee
where rn < 3;


-- Order of execution for window function:
1) Partition by
2) Order by
3) window funciton itself



-- Doubts:
4) Display all the available paintings and all the artist. If a painting was sold then mark them as "Sold".
    and if more than 1 painting of an artist was sold then display a "**" beside their name.

select p.name as painting_name
, case when x.no_of_paintings > 1
        then concat(a.first_name,' ', a.last_name, '**')
   else concat(a.first_name,' ', a.last_name)
end as artist_name
, case when s.id is not null then 'SOLD' end as sold_or_not
from paintings p
full outer join artists a on p.artist_id = a.id
left join sales s on s.painting_id = p.id
left join (select artist_id, count(1) no_of_paintings
       from sales group by artist_id ) x on x.artist_id = a.id;
