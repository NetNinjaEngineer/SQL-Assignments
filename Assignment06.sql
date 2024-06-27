-- 1. Create a view that displays the student's full name, course name if the student has a grade more than 50.
CREATE OR ALTER VIEW StudentWithCoursesBasedOn50GradeView
WITH ENCRYPTION
AS
	SELECT CONCAT(S.St_Fname, ' ', S.St_Lname) AS 'FullName', C.Crs_Name AS 'Course'
	FROM Stud_Course SC 
	INNER JOIN Student S ON SC.St_Id = S.St_Id
	INNER JOIN Course C ON C.Crs_Id = SC.Crs_Id
	WHERE SC.Grade > 50

SELECT * FROM StudentWithCoursesBasedOn50GradeView;

-- 2. Create an Encrypted view that displays manager names and the topics they teach.
CREATE OR ALTER VIEW ManagersWithTopicsTheyTeachView
WITH ENCRYPTION
AS
	SELECT INS.Ins_Name AS 'Manager', STRING_AGG(T.Top_Name, ' | ') AS 'Topics'
	FROM Ins_Course INSC 
	INNER JOIN Instructor INS ON INSC.Ins_Id = INS.Ins_Id
	INNER JOIN Course C ON C.Crs_Id = INSC.Crs_Id
	INNER JOIN Topic T ON T.Top_Id = C.Top_Id
	INNER JOIN Department D ON D.Dept_Manager = INS.Ins_Id
	GROUP BY INS.Ins_Name


SELECT * FROM ManagersWithTopicsTheyTeachView;

-- 3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding
CREATE OR ALTER VIEW V_GetInstructorsInSDJavaDepartments
WITH ENCRYPTION, SCHEMABINDING
AS
	SELECT INS.Ins_Name AS 'Instructor', D.Dept_Name AS 'Department'
	FROM Instructor INS INNER JOIN Department D
	ON D.Dept_Id = INS.Ins_Id
	WHERE D.Dept_Name IN ('SD', 'Java')

SELECT * FROM V_GetInstructorsInSDJavaDepartments;

-- ===> CAN NOT TRANFER THE TABLES FROM OUR SCHEMA TO ANOTHER SCHEMA AND CHANGE THE STRUCTURE OF THE TABLES
-- with schemabinding can not check on meta data which is better for performance
-- can not bind V_GetInstructorsInSDJavaDepartments because an object cannot reference itself

--4. Create a view “V1” that displays student data for students who live in Alex or Cairo. 
	--Note: Prevent the users to run the following query 
	--Update V1 set st_address=’tanta’
	--Where st_address=’alex’;

CREATE OR ALTER VIEW V1(StdId, StdFname, StdLname, StdAddress)
WITH ENCRYPTION
AS
	SELECT S.St_Id, S.St_Fname, S.St_Lname, S.St_Address
	FROM Student S WHERE S.St_Address IN ('Alex', 'Cairo')
	WITH CHECK OPTION

SELECT * FROM V1;
INSERT INTO V1(StdId, StdFname, StdLname, StdAddress) 
VALUES (5000, 'Ali', 'Mahmoud', 'Cairo')

UPDATE V1 SET StdAddress='tanta' WHERE StdAddress='Alex'

-- 5.	Create a view that will display the project name and the number of employees working on it. (Use Company DB)
USE MyCompany;
GO
CREATE OR ALTER VIEW V_EmployeesWithProjects(ProjectName, NumOfEmployees)
WITH ENCRYPTION
AS
	SELECT P.Pname, COUNT(E.SSN)
	FROM MyCompany.dbo.Works_for W
	INNER JOIN MyCompany.dbo.Employee E ON W.ESSn = E.SSN
	INNER JOIN MyCompany.dbo.Project P ON P.Pnumber = W.Pno
	GROUP BY P.Pnumber, P.Pname;

SELECT * FROM V_EmployeesWithProjects;

--1. Create a stored procedure to show the number of students per department.[use ITI DB]
USE ITI;
GO
CREATE OR ALTER PROC SP_GetNumberOfStudentsPerDepartment
WITH ENCRYPTION
AS
	SELECT D.Dept_Name AS 'Department',
		COUNT(S.St_Id) AS 'NumOfStudents'
	FROM Student S, Department D
	WHERE S.Dept_Id = D.Dept_Id
	GROUP BY D.Dept_Id, D.Dept_Name

EXEC SP_GetNumberOfStudentsPerDepartment

--2. Create a stored procedure that will check for the Number of employees
-- in the project 100 if they are more than 3 print message to the user 
-- “'The number of employees in the project 100 is 3 or more'” if they are less display 
-- a message to the user “'The following employees work for the project 100'” 
-- in addition to the first name and last name of each one. [MyCompany DB] 
USE MyCompany;
GO
CREATE OR ALTER PROC SP_CheckNumberOfEmployeesInProject100_DisplayMessage @PNO INT
WITH ENCRYPTION
AS
	DECLARE @numberOfEmployees INT, @message VARCHAR(MAX), @employees VARCHAR(MAX);
	SELECT @numberOfEmployees = COUNT(W.ESSn),
	@employees = STRING_AGG(CONCAT(E.Fname, ' ', E.Lname), ' | ')
	FROM MyCompany.dbo.Works_for W 
	INNER JOIN MyCompany.dbo.Project P ON P.Pnumber = W.Pno
	INNER JOIN MyCompany.dbo.Employee E ON E.SSN = W.ESSn
	WHERE P.Pnumber = @PNO

	IF @numberOfEmployees > 3
		SET @message = CONCAT('The number of employees in the project 100 is 3 or more, ', @employees)
	ELSE
		SET @message = CONCAT('The following employees work for the project 100, ', @employees)
	SELECT @message;

EXEC SP_CheckNumberOfEmployeesInProject100_DisplayMessage 100

--3. Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement. The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [MyCompany DB]
CREATE OR ALTER PROC SP_ReplaceEmployeeWorksOnProjectWithNewOne @oldNum INT, @newNum INT, @pNum INT
WITH ENCRYPTION
AS
	UPDATE MyCompany.dbo.Works_for
		SET ESSn = @newNum WHERE Pno = @pNum AND ESSn = @oldNum

EXEC SP_ReplaceEmployeeWorksOnProjectWithNewOne 112233, 521634, 100

-- PART 04
USE RouteCompany
GO

CREATE TABLE "Department" (
	"DeptNo" CHAR(2) PRIMARY KEY,
	"DeptName" VARCHAR(20),
	"Location" VARCHAR(2)
)
GO

CREATE TABLE "Employee" (
	"EmployeeNo" INT PRIMARY KEY,
	"EmpFname" VARCHAR(20) NOT NULL,
	"EmpLname" VARCHAR(20) NOT NULL,
	"DeptNo" CHAR(2),
	"Salary" MONEY UNIQUE,
	FOREIGN KEY ("DeptNo") REFERENCES Department("DeptNo")
)
GO

ALTER TABLE "Employee"
	ALTER COLUMN "EmpLname" VARCHAR(20) NOT NULL

-- DATA
INSERT INTO Department
	VALUES ('d1', 'Reasearch', 'NY'), ('d2', 'Accounting', 'DS'), ('d3', 'Marketing', 'KW')

INSERT INTO Employee(EmployeeNo, EmpFname, EmpLname, DeptNo, Salary)
	 VALUES (25348, 'Mathew', 'Smith', 'd3', 2500),
	 (10102, 'Ann', 'Jones', 'd3', 3000),
	 (18316, 'John', 'Barrymore', 'd1', 2400),
	 (29346, 'James', 'James', 'd2', 2800),
	 (9031, 'Lisa', 'Bertoni', 'd2', 4000),
	 (2581, 'Elisa', 'Hansel', 'd2', 3600),
	 (28559, 'Sybl', 'Moser', 'd1', 2900)



-- Testing Referential Integrity
-- 1. Add new employee with EmpNo =11111 In the works_on table [what will happen]
-- the insert statement conflicted with constraint FK_Works_on_Employee

-- 2. Change the employee number 10102  to 11111  in the works on table [what will happen]
-- the update statement conflicted with constraint FK_Works_on_Employee

-- 3. Modify the employee number 10102 in the employee table to 22222. [what will happen]
-- the update statement conflicted with constraint FK_Works_on_Employee

-- 4. Delete the employee with id 10102
DELETE FROM Employee WHERE EmployeeNo = 10102 -- IT WILL BE DELETED

-- Table Modification

--1- Add  TelephoneNumber column to the employee table[programmatically]

ALTER TABLE Employee ADD TelephoneNumber VARCHAR(20) NULL;

--2- drop this column[programmatically]

ALTER TABLE Employee DROP COLUMN TelephoneNumber

--3- Build A diagram to show Relations between tables


--2. Create the following schema and transfer the following tables to it 
	--a. Company Schema 
		--i. Department table	
		--ii. Project table 
		CREATE SCHEMA Company

		ALTER SCHEMA Company 
			TRANSFER Department

		ALTER SCHEMA Company 
			TRANSFER Project
		
	--b. Human Resource Schema
		--i. Employee table 
		CREATE SCHEMA HR

		ALTER SCHEMA HR
			TRANSFER Employee

--3. Increase the budget of the project where the manager number is 10102 by 10%.

UPDATE Company.Project
SET Budget = Budget + Budget * 0.1
FROM
Works_on W, HR.Employee E 
WHERE W.Job = 'Manager' 
	AND W.ProjectNo = Company.Project.ProjectNo 
	AND E.EmployeeNo = W.EmpNo
	AND W.EmpNo = 10102;

--4. Change the name of the department for which the employee named James works.The new department name is Sales.
UPDATE Company.Department
SET DeptName = 'Sales'
FROM HR.Employee E WHERE E.DeptNo = Company.Department.DeptNo AND E.EmpFname = 'James'

--5. Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.

UPDATE Works_on
SET Enter_Date = '2007-12-12'
FROM
	HR.Employee, Company.Project, Company.Department
	WHERE Works_on.EmpNo = HR.Employee.EmployeeNo
		AND Company.Project.ProjectNo = Works_on.ProjectNo
		AND Company.Department.DeptNo = HR.Employee.DeptNo
		AND Company.Project.ProjectName = 'p1'
		AND Company.Department.DeptName = 'Sales'

--6. Delete the information in the works_on table for all employees who work for the department located in KW.

DELETE FROM Works_on
FROM 
	HR.Employee, Company.Department
	WHERE Company.Department.DeptNo = HR.Employee.DeptNo
	AND Works_on.EmpNo = HR.Employee.EmployeeNo
	AND Company.Department.Location = 'KW'