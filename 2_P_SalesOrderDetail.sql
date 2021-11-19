create or alter PROCEDURE P_SalesOrderDetail

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- 첫번째 sql
	SELECT OD1.*
		INTO #TEMP001
	FROM Sales.SalesOrderDetail AS OD1
		JOIN Sales.SalesOrderDetail AS OD2		ON OD1.SalesOrderID = OD2.SalesOrderID

	-- 두번째 sql
	SELECT OD3.*
		INTO #TEMP002
	FROM
	(
		SELECT OD1.*
		FROM Sales.SalesOrderDetail AS OD1
			JOIN Sales.SalesOrderDetail AS OD2	ON OD1.SalesOrderID = OD2.SalesOrderID
	) AS _OD
		JOIN Sales.SalesOrderDetail OD3 ON _OD.SalesOrderID = OD3.SalesOrderID

	SELECT TOP 10 *
	FROM #TEMP002
END
GO

SELECT *
FROM Sales.SalesOrderDetail