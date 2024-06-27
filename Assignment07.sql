--1. Create a trigger to prevent anyone from inserting a new record in the Department table ( Display a message for user to tell him that he can’t insert a new record in that table )
CREATE OR ALTER TRIGGER TRI_PreventInsertOnDepartment
ON Department
INSTEAD OF INSERT
AS
    SELECT 'can’t insert a new record in that table'

-- INSERT INTO Department(Dept_Id, Dept_Name)
-- VALUES(100, 'Test') -- Invalid

-- 2.	Create a table named “StudentAudit”. Its Columns are (Server User Name , Date, Note) 

CREATE TABLE "StudentAudit" (
    ServerUserName VARCHAR(50),
    Note VARCHAR(MAX),
    Date DATE
)

ALTER TABLE "StudentAudit"
ALTER COLUMN Note VARCHAR(MAX)

-- Create a trigger on student table after insert to add Row in StudentAudit table 
-- ●	 The Name of User Has Inserted the New Student  
-- ●	Date
-- ●	Note that will be like ([username] Insert New Row with Key = [Student Id] in table [table name]


CREATE OR ALTER TRIGGER TRI_InsertInStudentAudit 
ON Student AFTER INSERT
AS 
    DECLARE @message VARCHAR(MAX), @key INT;
	SELECT @key = St_Id FROM inserted
    SET @message = SUSER_NAME() + ' Insert New Row with Key = ' + CAST(@key AS varchar(MAX))
    INSERT INTO StudentAudit(ServerUserName, Note, Date) 
        VALUES (SUSER_NAME(), @message, GETDATE())
GO

INSERT INTO Student(St_Id, St_Fname, St_Lname)
VALUES (1099226, 'Mohamed', 'ElHelaly');


--3. Create a trigger on student table instead of delete to add Row in StudentAudit table 
-- (The Name of User Has Inserted the New Student, Date, and note that will be like “try to delete Row with id = [Student Id]” )

CREATE OR ALTER TRIGGER TRI_InsertInStudentAuditInsteadOfDelete
ON Student INSTEAD OF DELETE
AS 
    DECLARE @message VARCHAR(MAX), @key INT;
	SELECT @key = St_Id FROM deleted
    SET @message = SUSER_NAME() + ' try to delete Row with id = ' + CAST(@key AS varchar(MAX))
    INSERT INTO StudentAudit(ServerUserName, Note, Date) 
        VALUES (SUSER_NAME(), @message, GETDATE())
GO

-- Use MyCompany DB:
--1. Create a trigger that prevents the insertion Process for Employee table in March.
USE MyCompany;
GO
CREATE OR ALTER TRIGGER TRI_PreventInsertEmployeeOnMarch
ON Employee INSTEAD OF INSERT
AS
	IF FORMAT(GETDATE(), 'MMMM') = 'March'
		SELECT 'you can not insert in this table in march' AS Error
GO


-- Use ITI DB :

--1. Create an index on column (Hiredate) that allows you to cluster the data in table Department. What will happen?
	CREATE CLUSTERED INDEX IX_Department_HireDate ON Department(Manager_hiredate) -- Invalid
-- Cannot create more than one clustered index on table 'Department'

--2. Create an index that allows you to enter unique ages in the student table. What will happen?
	CREATE UNIQUE INDEX IX_Student_Age ON Student(St_Age)
-- age column contains repeated values that voilates uniquness constraint
-- The CREATE UNIQUE INDEX statement terminated because a duplicate key was found for the object name 'dbo.Student' and the index name 'IX_Student_Age'. The duplicate key value is (<NULL>)