use library_management_project;

-- Tables
select * from members ;
select * from branch;
select * from employees;
select * from books ;
select * from issued_status ;
select * from return_status ;

-- Inserting New Values
INSERT INTO issued_status
(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151','C118','The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 DAY,'978-0-553-29698-2','E108'),
('IS152','C119','The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 DAY,'978-0-553-29698-2','E109'),
('IS153','C106','Pride and Prejudice', CURRENT_DATE - INTERVAL 7 DAY,'978-0-14-143951-8','E107'),
('IS154','C105','The Road', CURRENT_DATE - INTERVAL 32 DAY,'978-0-375-50167-0','E101');

ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(15) DEFAULT 'Good';

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id IN ('IS112','IS117','IS118');
-- Q13. Identify members who have overdue books.
select  iss.issued_member_id,m.member_name,b.book_title,iss.issued_date,current_date()-iss.issued_date as overdue_days
from issued_status iss
join members m 
on iss.issued_member_id=m.member_id
join books b 
on iss.issued_book_isbn=b.isbn
left join return_status rs
on iss.issued_id=rs.issued_id
where rs.return_date is null and current_date()-iss.issued_date>30
order by 1;

-- Q14. Write a query or procedure to update book status to "yes" when a book is returned.
-- Stored Procedure
DELIMITER //

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- Insert into return_status
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE(), p_book_quality);

    -- Get book details
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- Update book status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    -- Print message
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;

END //

DELIMITER ;

CALL add_return_records('RS138','IS135','Good');
CALL add_return_records('RS148','IS140','Good');



-- Q15. Branch Performance Report
create table branch_report as 
(
Select b.branch_id,
	   b.manager_id,
       count(ist.issued_id) as number_book_issued,
       count(rs.return_id) as number_book_return,
       sum(bk.rental_price) as total_revenue
       
from issued_status as ist
join employees e 
on e.emp_id=ist.issued_emp_id
join 
branch  b
on e.branch_id=b.branch_id
left join
return_status rs
on rs.issued_id=ist.issued_id
join 
books bk
on ist.issued_book_isbn=bk.isbn
group by 1,2
);

-- Q16. Create A table of Active Members OF LAST 6 MONTH
create table active_members as
select * from members
where member_id in (
select distinct issued_member_id
from issued_status
where issued_date>=current_date - interval 6 MONTH 
);

-- Q17. Find the top 3 employees who processed the most book issues.
select e.emp_name,
	   b.*,
	   count(ist.issued_id) as number_book_issued
from issued_status ist 
join employees e 
on e.emp_id=ist.issued_emp_id
join branch b
on e.branch_id=b.branch_id
group by 1,2;

-- Q18. Identify members who issued damaged books more than twice.
SELECT 
    m.member_name,
    iss.issued_book_name AS book_title,
    COUNT(*) AS times_issued
FROM return_status rs
JOIN issued_status iss
ON rs.issued_id = iss.issued_id
JOIN members m
ON iss.issued_member_id = m.member_id
WHERE rs.book_quality = 'Damaged'
GROUP BY m.member_name, iss.issued_book_name
HAVING COUNT(*) > 2;

-- Q19. Create a stored procedure that issues a book only if its status is available.
-- If not available, display an error message.
DELIMITER //

CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(10),
    IN p_issued_member_id VARCHAR(10),
    IN p_issued_book_name VARCHAR(75),
    IN p_issued_book_isbn VARCHAR(25),
    IN p_issued_emp_id VARCHAR(10)
)

BEGIN

    DECLARE v_status VARCHAR(10);

    -- Check book availability
    SELECT status
    INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    -- If available
    IF v_status = 'yes' THEN

        -- Insert issue record
        INSERT INTO issued_status
        (
            issued_id,
            issued_member_id,
            issued_book_name,
            issued_date,
            issued_book_isbn,
            issued_emp_id
        )
        VALUES
        (
            p_issued_id,
            p_issued_member_id,
            p_issued_book_name,
            CURRENT_DATE(),
            p_issued_book_isbn,
            p_issued_emp_id
        );

        -- Update book status
        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        -- Success message
        SELECT 'Book Issued Successfully' AS Message;

    ELSE

        -- Error message
        SELECT 'Book is currently unavailable' AS Message;

    END IF;

END //

DELIMITER ;

-- Procedure Calling
CALL issue_book(
'IS200',
'C101',
'1984',
'978-0-679-64115-3',
'E101'
);


-- Q20. Create a CTAS table for overdue books
CREATE TABLE overdue_books_report AS

SELECT 
    iss.issued_member_id AS member_id,
    
    COUNT(*) AS overdue_books,
    
    COUNT(iss.issued_id) AS total_books_issued,
    
    SUM(
        (DATEDIFF(CURRENT_DATE(), iss.issued_date) - 30) * 0.50
    ) AS total_fine

FROM issued_status iss

LEFT JOIN return_status rs
ON iss.issued_id = rs.issued_id

WHERE rs.return_id IS NULL
AND DATEDIFF(CURRENT_DATE(), iss.issued_date) > 30

GROUP BY iss.issued_member_id;

SELECT * FROM overdue_books_report;