-- step1
select *
from person.Person
where FirstName = 'ken'

select *
from person.Person
where FirstName = 'rob'

-- step2
exec P_PersonAll 'ken';
exec P_PersonAll 'rob';

-- step3
exec P_SalesOrderDetail

-- step6
exec P_Main