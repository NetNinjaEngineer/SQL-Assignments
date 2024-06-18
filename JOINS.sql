SELECT * FROM Department;
SELECT * FROM Course;

SELECT COUNT(Dept_Id) FROM Department; -- 7
SELECT COUNT(Crs_Id) FROM Course; -- 12

-- CROSS JOIN 
-- ANSI SQL
SELECT * FROM Department, Course; -- 7 * 12 = 84
-- NEW SYNTAX
SELECT * FROM Department CROSS JOIN Course;

-- INNER JOIN 
SELECT 
CONCAT(S.St_Fname, ' ', S.St_Lname) AS Student ,
C.Crs_Name AS 'Course' FROM 
Stud_Course SC INNER JOIN Student S ON SC.St_Id = S.St_Id
INNER JOIN Course C ON C.Crs_Id = SC.Crs_Id;


-- RIGHT OUTER JOIN
SELECT S.St_Fname, D.Dept_Name
FROM Student S RIGHT OUTER JOIN Department D
ON S.Dept_Id = D.Dept_Id;

-- LEFT OUTER JOIN
SELECT S.St_Fname, D.Dept_Name
FROM Student S LEFT OUTER JOIN Department D
ON S.Dept_Id = D.Dept_Id;

-- FULL OUTER JOIN
SELECT S.St_Fname, D.Dept_Name
FROM Student S FULL OUTER JOIN Department D
ON S.Dept_Id = D.Dept_Id;

-- SELF JOIN

SELECT S.St_Fname AS Student, SuperVisor.St_Fname AS 'Super visor' 
FROM Student S INNER JOIN Student SuperVisor
ON S.St_super = SuperVisor.St_Id;

-- Multi table join
SELECT CONCAT(S.St_Fname, ' ', S.St_Lname) AS 'Student',
C.Crs_Name AS 'Course', sc.Grade
FROM Stud_Course SC INNER JOIN Course C
ON SC.Crs_Id =  C.Crs_Id
INNER JOIN Student S ON S.St_Id = SC.St_Id;


-- INCREMENT STUDENT GRADE BY 10 FOR STUDENTS LIVING IN CAIRO
SELECT * FROM Stud_Course;
SELECT * FROM Course;
SELECT * FROM Student;

UPDATE Stud_Course
SET Grade += 10
FROM Student S INNER JOIN Stud_Course SC
ON S.St_Id = SC.St_Id AND S.St_Address = 'Cairo'


-- AGGREGATE FUNCTIONS
SELECT COUNT(*) FROM Student;

SELECT D.Dept_Name AS 'Department',
COUNT(S.St_Id) AS 'NumberOfStudents'
FROM Student S INNER JOIN Department D
ON S.Dept_Id = D.Dept_Id
GROUP BY S.Dept_Id, D.Dept_Name;

SELECT D.Dept_Name AS 'Department',
COUNT(S.St_Id) AS 'NumberOfStudents'
FROM Student S INNER JOIN Department D
ON S.Dept_Id = D.Dept_Id
GROUP BY S.Dept_Id, D.Dept_Name
HAVING COUNT(S.St_Id) > 3;

SELECT D.Dept_Id , 
D.Dept_Name AS 'Department', 
SUM(S.Salary) AS 'Total',
COUNT(S.Ins_Id) AS '#Instructors',
STRING_AGG(S.Ins_Name, ', ') AS 'Instructors'
FROM Department D INNER JOIN Instructor S
ON S.Dept_Id = D.Dept_Id
GROUP BY D.Dept_Id , D.Dept_Name
HAVING COUNT(S.Ins_Id) > 1;

-- COUNT OF STUDENTS FOR EACH SUPERVISOR

SELECT CONCAT(SuperVisor.St_Fname, ' ', SuperVisor.St_Lname) AS 'SuperVisor',
COUNT(S.St_Id) AS '#Students'
FROM Student S INNER JOIN Student SuperVisor
ON SuperVisor.St_Id = S.St_super
GROUP BY SuperVisor.St_Id, SuperVisor.St_Fname, SuperVisor.St_Lname;