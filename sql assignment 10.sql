#database name is teachers
create database teachers;
use  teachers;

-- create a table named teachers with fields id,name,subject,experience and salary and insert 8 rows.
create table teachers(Id int primary key not null, Name varchar(20) not null, subject varchar (15), 
experience int not null, salary int not null);
 desc teachers;
 
 insert into teachers (Id, Name, subject, experience, salary) 
 values (1,'sijo','physics',6,40000),(2,'anju','maths',8,70000),(3,'jinto','chemistry',4,50000),
 (4,'jim','malayalam',3,60000),(5,'tom','english',4,80000),(6,'aswathi','hindi',9,67000),
 (7,'pooja','biology',15,68000),(8,'meera','history',13,72000),(9,'nayan', 'physics',10,85000);
 
 select*from teachers;
 
-- 2. Create a before insert trigger named before_insert_teacher that will raise an error
-- “salary cannot be negative” if the salary inserted to the table is less than zero.

DELIMITER $$
CREATE  TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        signal sqlstate'50000' set message_text= 'salary cannot be negative';
END IF;
END $$
DELIMITER ;

show triggers from teachers;

insert into teachers values (9, 'suja','maths',3,-40000);

-- Create an after insert trigger named after_insert_teacher that inserts a row with teacher_id,action, 
-- timestamp to a table called teacher_log when a new entry gets inserted to the teacher table. 
-- tecaher_id -> column of teacher table, action -> the trigger action, 
-- timestamp -> time at which the new row has got inserted. 

create table teacher_log(Teacher_Id int not null,Action varchar (15) not null, Timestamp datetime not null);

select* from teacher_log;
 delimiter $$
CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (NEW_id, 'INSERT', now());
END $$
delimiter ;

INSERT INTO teachers VALUES( 10,'SUJA','MATHS',3,40000);
select * from teachers;
select *from teacher_log;

-- Create a before delete trigger that will raise an error when you try to
-- delete a row that has experience greater than 10 years.

DELIMITER $$
CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
	SIGNAL sqlstate '45000' SET message_text ='THIS TEACHER HAS MORE THAN 10 YEARS OF EXPERIENCE, CANNOT DELETE';
    END IF;
END $$
DELIMITER ;

delete from teachers where Id = 3;

-- Create an after delete trigger that will insert a row to teacher_log table when that row is deleted from teacher table.
delimiter $$
CREATE  TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (OLD.id, 'DELETE', now());
END $$
delimiter ;

delete from teachers where subject = 'biology';
set SQL_SAFE_UPDATES=0;
select* from teacher_log;

show triggers from teachers;



drop database teACHERS;
 