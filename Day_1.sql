-- library_management_project
use  library_management_project;

-- Day 1
-- Creating Branch Table
create table branch(
branch_id varchar(10) primary key,
manager_id varchar(10) ,
branch_address varchar(100),
contact_no varchar(12)
);

-- Creating Employees Table 
create table employees(
emp_id varchar(10) Primary key ,
emp_name varchar(30),
position varchar(30),
salary decimal(10,2),
branch_id varchar(10),
foreign key(branch_id) references branch(branch_id)
);

-- Creating Books Table 
Create table books(
isbn varchar(20) primary key,
book_title varchar(70) not null,
category varchar(30),
rental_price decimal(6,2),
status enum('yes','no') ,
author varchar(35),
publisher  varchar(50)
);

-- Creating members Table 
create table members(
member_id varchar(10) primary key,
member_name varchar(35) not null,
member_address varchar(60),
reg_date date not null
);

-- Creating issued_status Table 
create table issued_status(
issued_id varchar(10) primary key ,
issued_member_id varchar(10) ,
issued_book_name varchar(75) not null ,
issued_date date ,
issued_book_isbn varchar(25), 
issued_emp_id varchar(10),
foreign key (issued_member_id) references members(member_id),
foreign key (issued_book_isbn) references books(isbn),
foreign key (issued_emp_id) references employees(emp_id)
);

-- Creating return_status Table 
create table return_status(
return_id varchar(10) primary key,
issued_id varchar(10),
return_book_name varchar(70),
return_date date ,
return_book_isbn varchar(20),
foreign key (issued_id) references issued_status(issued_id)
);

ALTER TABLE branch
ADD FOREIGN KEY (manager_id) REFERENCES employees(emp_id);

select * from branch;