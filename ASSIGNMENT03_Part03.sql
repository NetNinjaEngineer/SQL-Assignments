SELECT * FROM Department;
SELECT * FROM Instructor;
SELECT * FROM Ins_Course;
SELECT * FROM Student;
SELECT * FROM Topic;	

-- DISPLAY SPECIFIC COLUMNS
SELECT St_Fname, St_Lname, St_Address
FROM Student;

-- DISPLAY FIRSTNAME AND LASTNAME CONCATENATED

SELECT CONCAT(Student.St_Fname, ' ', Student.St_Lname) AS 'StudentName' FROM Student;
SELECT S.St_Fname + ' ' + S.St_Lname AS 'STUDENT' FROM Student S;

-- DISPLAY ALL STUDENTS WITH AGE LESS THAN 23

SELECT *
FROM Student WHERE St_Age < 23;


-- DISPLAY COUNT OF ALL STUDENTS WITH AGE LESS THAN 23

SELECT COUNT(St_Id) AS '#OfStudentsLessThan23' FROM Student WHERE St_Age < 23;

SELECT 
COUNT(St_Id) AS '#OfStudentsLessThan25AndGreaterThan21' 
FROM Student WHERE St_Age >= 21 AND St_Age <= 25;

SELECT *
FROM Student WHERE St_Age >= 21 AND St_Age <= 25;

SELECT *
FROM Student WHERE St_Age IN (21, 22, 23, 24, 25);

SELECT
CONCAT(COUNT(St_Id), ' Students') AS '#OfStudentsLessThan25AndGreaterThan21' 
FROM Student WHERE St_Age IN (21, 22, 23, 24, 25);

SELECT *
FROM Student WHERE St_Age BETWEEN 21 AND 25;

SELECT 
CONCAT(COUNT(St_Id), ' Students') AS '#OfStudentsLessThan25AndGreaterThan21'
FROM Student WHERE St_Age BETWEEN 21 AND 25;

SELECT *
FROM Student WHERE St_Address IN ('Cairo', 'Alex', 'Mansoura');

SELECT CONCAT(COUNT(St_Id), ' Students') AS '#OfStudentsLivesInAlexOrCairoOrMansoura'
FROM Student WHERE St_Address IN ('Cairo', 'Alex', 'Mansoura');

SELECT *
FROM Student 
WHERE St_Address = 'Cairo' OR  St_Address = 'Alex' OR St_Address = 'Mansoura';

-- DIPLAY STUDENTS DO NOT LIVE IN 'Cairo', 'Alex', 'Mansoura'
SELECT *
FROM Student WHERE St_Address NOT IN ('Cairo', 'Alex', 'Mansoura');

SELECT DISTINCT St_Address FROM STUDENT WHERE St_Address IS NOT NULL; 

-- SELECT STUDENTS WITH NO SUPERVISOR
SELECT * FROM Student WHERE St_super IS NULL;

SELECT * FROM Student WHERE St_Fname LIKE '%e_' AND LEN(St_Fname) > 5;
SELECT * FROM Student WHERE St_Fname LIKE 'M%A';
SELECT * FROM Student WHERE St_Fname LIKE '[AMS]%';
SELECT * FROM Student WHERE St_Fname LIKE '[^AMS]%';
SELECT * FROM Student WHERE St_Fname LIKE '[A-H]%';
SELECT * FROM Student WHERE St_Age LIKE '[349]%';
SELECT * FROM Student WHERE St_Fname LIKE '%[%]';
SELECT * FROM Student WHERE St_Fname LIKE '[_]%[_]'; -- _HAHAHA_


SELECT DISTINCT St_Fname FROM STUDENT;

-- ORDER STUDENTS BY NAME

SELECT * FROM Student ORDER BY St_Fname; -- ASC

SELECT * FROM Student ORDER BY St_Fname DESC; -- DESC

SELECT * FROM Student ORDER BY St_Fname DESC, St_Lname; -- DESC
