create or alter PROCEDURE P_Sub2
AS
BEGIN

	-- 첫번째 sql
	SELECT top 10 OD1.*
		INTO #T1
	FROM Sales.SalesOrderDetail AS OD1


	-- 두번째 sql
	SELECT OD3.*
		INTO #T2
	FROM
	(
		SELECT OD1.*
		FROM Sales.SalesOrderDetail AS OD1
			JOIN Sales.SalesOrderDetail AS OD2	ON OD1.SalesOrderID = OD2.SalesOrderID
	) AS _OD
		JOIN Sales.SalesOrderDetail OD3 ON _OD.SalesOrderID = OD3.SalesOrderID

END
GO
