--sql project - library Management System N2

select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

/* Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

--issued_status==members==books==return_status
--filter books which are return
--overdue >30

select current_date

select m.member_id,m.member_name,bk.book_title,ist.issued_date,rs.return_date,(current_date - ist.issued_date) as overdue_days from issued_status as ist
join members as m
on ist.issued_member_id=m.member_id
join books as bk
on bk.isbn=ist.issued_book_isbn
left join return_status as rs
on rs.issued_id=ist.issued_id
where rs.return_date is null
and
(current_date - ist.issued_date) >30
order by 1;

/*
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/

select * from issued_status
where issued_id='IS130';

update books
set status='no'
where isbn='978-0-451-52994-2';

select * from books
where isbn='978-0-451-52994-2';


insert into return_status (return_id,issued_id,return_date,book_quality)
values 
('RS125','IS130',current_date,'Good');

select * from return_status
where issued_id='IS130';


--store Procedures
create or replace procedure add_return_records(p_return_id varchar(10),p_issued_id varchar(10),p_book_quality varchar(10))
language plpgsql
as $$

declare
v_isbn varchar(50);
v_book_name varchar(80);

begin

insert into return_status(return_id,issued_id,return_date,book_quality)
values 
(p_return_id,p_issued_id,current_date,p_book_quality);

select
issued_book_isbn,
book_title
into
v_isbn,
v_book_name
from issued_status
where issued_id=p_issued_id;

update books
set status='yes'
where isbn=v_isbn;

raise notice 'thank you for returning the book %',v_book_name;
end;
$$





