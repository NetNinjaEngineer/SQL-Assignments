-- 1.	Display the Department id, name and id and the name of its manager.
SELECT
D.Dnum AS 'DepartmentID',
Dname AS 'DepartmentName',
E.SSN AS 'ManagerId',
CONCAT(E.Fname, ' ', E.Lname) AS 'Manager'
FROM Departments D INNER JOIN Employee E
 ON D.MGRSSN = E.SSN;


 -- 2.	Display the name of the departments and the name of the projects under its control.

 SELECT D.Dname AS 'Department', P.Pname AS 'ProjectUnderControl'
 FROM Departments D JOIN Project P
 ON D.Dnum = P.Dnum

 -- 3.	Display the full data about all the dependence associated with the name of the employee they depend on .
 SELECT *
 FROM Employee E JOIN Dependent D
 ON  D.ESSN = E.SSN


 -- 4.	Display the Id, name and location of the projects in Cairo or Alex city.
 SELECT Pname, Pnumber, Plocation FROM Project WHERE City IN ('Alex', 'Cairo');

 -- 5.	Display the Projects full data of the projects with a name starting with "a" letter.
 SELECT * FROM Project WHERE Pname LIKE 'a%';


 -- 6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly

 SELECT *
 FROM Employee E
 WHERE (E.Salary BETWEEN 1000 AND 2000) AND Dno = 30;

 -- 7.	Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.

 SELECT * FROM Employee;
 SELECT * FROM Project;
 SELECT * FROM Works_for;

SELECT 
CONCAT(E.Fname, ' ', E.Lname) AS 'Employee'
FROM Works_for W INNER JOIN Employee E ON W.ESSn = E.SSN
INNER JOIN Project P ON P.Pnumber = W.Pno
WHERE E.Dno = 10 AND W.Hours >= 10 AND P.Pname = 'AL Rabwah';


-- 8.	Find the names of the employees who were directly supervised by Kamel Mohamed.
SELECT CONCAT(E.Fname, ' ', E.Lname) AS Employee,
CONCAT(SuperVisor.Fname, ' ', SuperVisor.Lname) AS SuperSSN
FROM Employee E INNER JOIN Employee SuperVisor
ON E.Superssn = SuperVisor.SSN
WHERE CONCAT(SuperVisor.Fname, ' ', SuperVisor.Lname) = 'Kamel Mohamed';

-- 9.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
SELECT CONCAT(E.Fname, ' ', E.Lname) AS Employee,
P.Pname AS 'Project'
FROM Works_for W INNER JOIN Employee E ON W.ESSn = E.SSN
INNER JOIN Project P ON P.Pnumber = W.Pno
ORDER BY P.Pname;

-- 10.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
SELECT p.Pnumber, D.Dname, CONCAT(E.Fname, ' ', E.Lname) AS 'Manager'
FROM Project P INNER JOIN Departments D ON P.Dnum = D.Dnum
INNER JOIN Employee E ON E.SSN = D.MGRSSN
WHERE P.City = 'Cairo'

-- 11.	Display All Data of the managers
SELECT Fname, Lname, SSN, Bdate, Address, Sex, Salary, Superssn, Dno
FROM Employee E INNER JOIN Departments D
ON E.SSN = D.MGRSSN;

-- 12.	Display All Employees data and the data of their dependents even if they have no dependents.
SELECT E.SSN AS 'Employee', D.ESSN AS 'Dependent'
FROM Employee E LEFT OUTER JOIN Dependent D
ON D.ESSN = E.SSN;