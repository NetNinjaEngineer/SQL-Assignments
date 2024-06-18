SELECT CONCAT(E.Fname, ' ', E.Lname) AS 'Employee',
CONCAT(Manager.Fname, ' ', Manager.Lname) AS 'Manager'
FROM Employee E INNER JOIN Employee Manager
ON E.Superssn = Manager.SSN;

SELECT * FROM Employee;

-- AGGREGATE FUNCTIONS
SELECT COUNT(*) FROM Employee;
SELECT SUM(Salary) FROM Employee;
SELECT AVG(Salary) FROM Employee;
SELECT SUM(Salary) / COUNT(Salary) FROM Employee;

SELECT * FROM Departments;
SELECT * FROM Employee;

SELECT E.Dno AS 'Department', MIN(E.Salary) AS 'Min Salary'
FROM Employee E 
WHERE E.DNO IS NOT NULL
GROUP BY E.Dno, E.Dno;