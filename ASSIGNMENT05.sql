-- 1.	Create a scalar function that takes a date and returns the Month name of that date.
CREATE OR ALTER FUNCTION dbo.GetMonthNameFromDate(@date DATE)
RETURNS VARCHAR(20)
BEGIN
	DECLARE @MonthName VARCHAR(20)
	SELECT @MonthName = FORMAT(@date, 'MMMM')
	RETURN @MonthName;
END

SELECT dbo.GetMonthNameFromDate(GETDATE()) AS 'Month'

-- 3. Create a table-valued function that takes Student No and returns Department Name with Student full name.
CREATE FUNCTION dbo.GetStudentFullNameWithDepartmentBySTDNO(@stdNumber INT)
RETURNS TABLE
AS RETURN (
	SELECT 
	CONCAT(S.St_Fname, ' ', S.St_Lname) AS 'FullName',
	D.Dept_Name AS 'Department'
	FROM Student S , Department D
	WHERE S.Dept_Id = D.Dept_Id AND S.St_Id = @stdNumber
);

SELECT * FROM GetStudentFullNameWithDepartmentBySTDNO(5)

--4. Create a scalar function that takes Student ID and returns a message to user 
	--a.	If first name and Last name are null then display 'First name & last name are null'
	--b.	If First name is null then display 'first name is null'
	--c.	If Last name is null then display 'last name is null'
	--d.	Else display 'First name & last name are not null'

CREATE OR ALTER FUNCTION dbo.GetMessageToUserBySTDID(@stdId INT)
RETURNS VARCHAR(70)
BEGIN
	DECLARE @firstName VARCHAR(20), @lastName VARCHAR(20), @message VARCHAR(70);
	SELECT @firstName = St_Fname, @lastName = St_Lname 
		FROM Student S WHERE S.St_Id = @stdId;

	IF (@firstName IS NULL AND @lastName IS NULL)
		SET @message = 'First name & last name are null'
	ELSE IF (@firstName IS NULL)
		SET @message = 'first name is null'
	ELSE IF (@lastName IS NULL)
		SET @message = 'last name is null'
	ELSE
		SET @message = 'First name & last name are not null'

	RETURN @message;
END

SELECT dbo.GetMessageToUserBySTDID(13) AS 'Message'

-- 5. Create a function that takes an integer which represents the format of the Manager hiring date and displays department name, Manager Name and hiring date with this format.

CREATE OR ALTER FUNCTION dbo.GetMangerOfDepartmentByHireDateFormat(@format VARCHAR(50))
RETURNS TABLE
AS RETURN (
	SELECT 
		D.Dept_Name AS 'DepartmentName',
		INS.Ins_Name AS 'ManagerName',
		FORMAT(D.Manager_hiredate, @format) AS 'Hire Date'
	FROM Department D INNER JOIN Instructor INS
	ON D.Dept_Manager = INS.Ins_Id
);

-- Use DIFFERENT FORMATS AS YOU LIKE 
select * from dbo.GetMangerOfDepartmentByHireDateFormat('MMMM')
select * from dbo.GetMangerOfDepartmentByHireDateFormat('MMMM yyyy')
select * from dbo.GetMangerOfDepartmentByHireDateFormat('dd MMMM yyyy')
select * from dbo.GetMangerOfDepartmentByHireDateFormat('dd MMM yyyy')



--6. Create multi-statement table-valued function that takes a string
--a. If string='first name' returns student first name
--b. If string='last name' returns student last name 
--c. If string='full name' returns Full Name from student table  
-- Note: Use �ISNULL� function

CREATE OR ALTER FUNCTION dbo.GetDataBasedFormat(@Format varchar(20))
RETURNS @T TABLE
(
	StdId int,
	StdName varchar(20)
)
AS
BEGIN
	if @Format = 'first name'
	insert into @T
	select St_Id, ISNULL(St_Fname, '') from Student;
	else if @Format = 'last name'
	insert into @T
	select St_Id, ISNULL(St_Lname, '') from Student;
	else if @Format = 'full name'
	insert into @T
	select St_Id, CONCAT(St_Fname, ' ', St_Lname) from Student;
	return;
END

select * from dbo.GetDataBasedFormat('last name')

-- 7. Create function that takes project number and display all employees 
-- in this project (Use MyCompany DB)
USE MyCompany;
GO

CREATE OR ALTER FUNCTION dbo.GetAllEmployeeWorksInSpecificProjectByPNO(@projectNumber INT)
RETURNS TABLE
AS RETURN (
	SELECT P.Pname AS 'Project', CONCAT(E.Fname, ' ', E.Lname) AS 'Employee'
	FROM MyCompany.dbo.Works_for W 
	INNER JOIN MyCompany.dbo.Employee E ON W.ESSn = E.SSN
	INNER JOIN MyCompany.dbo.Project P ON P.Pnumber = W.Pno
	WHERE W.Pno = @projectNumber
)

select * from MyCompany.dbo.GetAllEmployeeWorksInSpecificProjectByPNO(400)

CREATE OR ALTER PROC SP_GetEmployeesNumbersWorksInSpecifiedProjectByPNO @pno INT
WITH ENCRYPTION
AS
	SELECT Project, COUNT(Employee) AS 'NumberOfEmployees', STRING_AGG(Employee, ' | ') AS EmployeesAssigned
	FROM MyCompany.dbo.GetAllEmployeeWorksInSpecificProjectByPNO(@pno)
	GROUP BY Project


EXEC SP_GetEmployeesNumbersWorksInSpecifiedProjectByPNO 300