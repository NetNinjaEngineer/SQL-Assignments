-- DISPLAY ALL EMPLOYEES DATA
SELECT * FROM Employee;

-- 2.Display the employee First name, last name, Salary and Department number.
SELECT Fname, Lname, Dno FROM Employee;

-- 3.Display all the projects names, locations and the department which is responsible for it
SELECT Pname, Plocation, Dnum FROM Project;
SELECT
Pname, Plocation, D.Dname
FROM Project P JOIN Departments D
 ON P.Dnum = D.Dnum;


 -- 4.If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
 SELECT 
	CONCAT(Fname, ' ', Lname) AS FULLNAME,
	Salary * 12 * 0.1 AS [ANNUAL COMM]
	FROM Employee

-- 5.	Display the employees Id, name who earns more than 1000 LE monthly.
SELECT SSN, CONCAT(Fname, ' ', Lname) AS NAME FROM Employee WHERE Salary > 1000;

-- 6.	Display the employees Id, name who earns more than 10000 LE annually.
SELECT *, (Salary * 12) AS [ANNUAL SALARY] FROM Employee;
SELECT * FROM Employee WHERE (Salary * 12) > 10000;

-- 7.	Display the names and salaries of the female employees 
SELECT Fname, Lname, Salary FROM Employee WHERE Sex = 'F';


-- 8.	Display each department id, name which is managed by a manager with id equals 968574.

SELECT * FROM Departments WHERE MGRSSN = 968574

-- 9.	Display the ids, names and locations of  the projects which are controlled with department 10.

SELECT Pnumber, Pname, Plocation FROM Project WHERE Dnum = 10;

-- 1.	Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO Employee (SSN, Fname, Lname, Bdate, Sex, Salary, Superssn, Dno)
VALUES (889955,'Mohamed', 'Ehab', '7-10-1980', 'M', 3000, 112233, 30);

INSERT INTO Employee (SSN, Salary, Superssn, Dno)
VALUES (102660, 3000, 112233, 30);

-- 3.	Upgrade your salary by 20 % of its last value.
UPDATE Employee SET Salary += Salary * 0.2 WHERE SSN = 102660;

SELECT * FROM Employee WHERE SSN = 102660;