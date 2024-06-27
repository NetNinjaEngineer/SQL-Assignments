
-- 1.	Retrieve a number of students who have a value in their age
SELECT COUNT(S.St_Id) FROM Student S WHERE S.St_Age IS NOT NULL;

-- 2.	Display number of courses for each topic name
SELECT T.Top_Name AS 'Topic' , COUNT(C.Crs_Id) AS 'NumOfCourses'
FROM Course C INNER JOIN Topic T
ON C.Top_Id = T.Top_Id
GROUP BY C.Top_Id, T.Top_Name;

-- 3.	Select Student first name and the data of his supervisor 
SELECT S.St_Fname AS 'Student Fname',
SuperVisor.St_Id, SuperVisor.St_Fname, SuperVisor.St_Lname,
SuperVisor.St_Address, SuperVisor.St_Age, SuperVisor.Dept_Id, SuperVisor.St_super
FROM Student S INNER JOIN Student SuperVisor
ON S.St_super = SuperVisor.St_Id

-- 4.	Display student with the following Format (use isNull function)
SELECT S.St_Id AS 'Student ID',
CONCAT(S.St_Fname, ' ', ISNULL(S.St_Lname, 'NOT FOUND')) AS 'Student Full Name',
D.Dept_Name AS 'Student Full Name'
FROM Student S INNER JOIN Department D
ON S.Dept_Id = D.Dept_Id;


-- 5. Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function”
SELECT 
INS.Ins_Name, 
ISNULL(INS.Salary, 0000) AS Salary 
FROM Instructor INS;

-- 6. Select Supervisor first name and the count of students who supervises on them
SELECT SuperVisor.St_Fname, COUNT(S.St_Id) AS 'CountOfStudents'
FROM Student S INNER JOIN Student SuperVisor
ON S.St_super = SuperVisor.St_Id
GROUP BY SuperVisor.St_Fname;

-- 7. Display max and min salary for instructors
SELECT MAX(INS.Salary) AS 'Max', MIN(INS.Salary) AS 'Min' FROM Instructor INS;

-- 8. Select Average Salary for instructors 
SELECT AVG(INS.Salary) FROM Instructor INS;

-- 9. For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT P.Pname, SUM(W.Hours) AS 'TotalHours'
FROM Project P INNER JOIN Works_for W
ON P.Pnumber = W.Pno
GROUP BY W.Pno, P.Pname;

-- 10. For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

SELECT D.Dnum, D.Dname, MIN(E.Salary) AS 'Min Salary', MAX(E.Salary) AS 'Max Salary'
FROM Employee E INNER JOIN Departments D
ON E.Dno = D.Dnum
GROUP BY D.Dnum, D.Dname;

-- 11. DISPLAY INSTRUCTORS WHO HAVE SALARY LESS THAN AVERAGE SALARY OF ALL INSTRUCTORS

SELECT *
FROM Instructor AS INS
WHERE INS.Salary < (SELECT AVG(INS.Salary) FROM Instructor INS);

-- 12. Display department name that contains instructor who receives minumum salary
SELECT *
FROM Department D INNER JOIN Instructor INS
ON D.Dept_Id = INS.Dept_Id
WHERE INS.Salary = (SELECT MIN(INS.Salary) FROM Instructor INS);

-- 13. SELECT MAX TWO SALARIES IN INSTRUCTOR TABLE

-- USING TOP WITH ORDER BY

SELECT TOP(2) INS.Salary
FROM Instructor INS
WHERE INS.Salary IS NOT NULL
ORDER BY INS.Salary DESC;

-- USING RANKING

SELECT NEW.Salary, RN
FROM (
	SELECT INS.Salary, ROW_NUMBER() OVER (ORDER BY INS.Salary DESC) AS RN
	FROM Instructor INS
	WHERE INS.Salary IS NOT NULL
) AS NEW
WHERE RN <= 2;

-- 14.

SELECT Dept_Name, Salary
FROM (
	SELECT 
	INS.Ins_Name, 
	D.Dept_Name, 
	INS.Salary, 
	ROW_NUMBER() OVER (PARTITION BY D.Dept_Id ORDER BY INS.Salary DESC) AS RN
	FROM Instructor INS INNER JOIN Department D
	ON INS.Dept_Id = D.Dept_Id
	WHERE INS.Salary IS NOT NULL
) AS NEW
WHERE RN <= 2;


-- 13. SELECT RANDOM STUDENT FOR EACH DEPARTMENT USE RANKING FUNCTIONS
SELECT *
FROM (
	SELECT 
	D.Dept_Name,
	CONCAT(S.St_Fname, ' ', S.St_Lname) AS 'Student', 
	ROW_NUMBER() OVER (PARTITION BY D.Dept_Id ORDER BY NEWID() DESC) AS RN
	FROM Student S INNER JOIN Department D
	ON S.Dept_Id = D.Dept_Id
	WHERE S.Dept_Id IS NOT NULL
) AS NEW
WHERE RN = 1;

-- 14. DISPLAY DEPARTMENT DATA THAT HAVE SMALL EMPLOYEE ID OVER ALL EMPLOYEES IN THIS DEPARTMENT

SELECT D.Dname, MIN(E.SSN) AS 'Min ID'
FROM Employee E INNER JOIN Departments D
ON E.Dno = D.Dnum
GROUP BY D.Dnum, D.Dname;

-- 15. SELECT DNAME, DNUM, NUM OF EMPLOYEES IF AVG SALARY FOR EACH DEPARTMENT LESS THAN AVG FOR ALL EMPLOYEES
SELECT D.Dnum, D.Dname, COUNT(E.SSN) AS '#Employees'
FROM Departments D INNER JOIN Employee E
ON E.Dno = D.Dnum
GROUP BY D.Dnum, D.Dname
HAVING AVG(E.Salary) < (SELECT AVG(EM.Salary) FROM Employee EM)

-- 16. GET MAX 2 SALARIES USING SUB QUERY
SELECT NEW.Salary, RN
FROM (
	SELECT E.Salary, ROW_NUMBER() OVER (ORDER BY E.Salary DESC) AS RN
	FROM Employee E
	WHERE E.Salary IS NOT NULL
) AS NEW
WHERE RN <= 2;

-- USING TOP
SELECT *
FROM (
	SELECT TOP(2) E.Salary FROM Employee E ORDER BY E.Salary DESC
) AS NEW;

-- USING UNION
SELECT MAX(E.Salary) AS 'Max Salary'
FROM Employee E
UNION
SELECT MAX(E.Salary)
FROM Employee E
WHERE Salary < (SELECT MAX(Salary) FROM Employee);

-- 17. SELECT EMPLOYEE NUMBER AND NAME IF AT LEAST HAVE ONE DEPENDENT

SELECT DISTINCT E.SSN, CONCAT(E.Fname, ' ', E.Lname) AS 'FullName'
FROM Employee E INNER JOIN Dependent D
ON E.SSN = D.ESSN
AND EXISTS(SELECT ESSN FROM Dependent);

SELECT E.SSN, CONCAT(E.Fname, ' ', E.Lname) AS 'FullName'
FROM Employee E
WHERE EXISTS(
	SELECT D.ESSN FROM Dependent D WHERE D.ESSN = E.SSN
);