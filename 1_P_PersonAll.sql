CREATE PROCEDURE P_PersonAll 
	-- Add the parameters for the stored procedure here
	@pName nvarchar(200) 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM Person.Person
	WHERE FirstName = @pName
END
GO
