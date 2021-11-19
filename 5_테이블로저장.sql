/*
USE ForDBTuning
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'XEventTrace')
	DROP TABLE XEventTrace

	delete XEventTrace
*/

CREATE TABLE XEventTrace (
        TraceSeq int identity(1,1) not null Primary key,
        -- [SessionId] [bigint] not NULL,
        [EventName] [nvarchar](200) NULL,
		[EventDate] [datetime] NULL,
		[CpuTimeMs] [bigint] NULL,
		[DurationMs] [bigint] NULL,
		[PhysicalReads] [bigint] NULL,
		[LogicalReads] [bigint] NULL,
		[Writes] [bigint] NULL,
		[RowCounts] [bigint] NULL,
		[EventResult] [nvarchar](256) NULL,
        [PlanHandle] bigint null,
        [QueryHash] binary(8) null,
        [QueryPlanHash] binary(8) null,
		[DatabaseName] [nvarchar](128) NULL,
		[UserName] [nvarchar](256) NULL,
		[ClientHostName] [nvarchar](256) NULL,
		[ClientAppName] [nvarchar](256) NULL,
		[BatchText_Statement] [nvarchar](max) NULL,        -- rpc_complete의 옵션필드인 statement와 sql_batch_completed의 옵션필드인 batch_text를 통합
		[SqlText] [nvarchar](max) NULL		
	)
GO

INSERT INTO XEventTrace (EventName, EventDate, CpuTimeMs, DurationMs, PhysicalReads, LogicalReads, Writes, RowCounts, EventResult
	, PlanHandle, QueryHash, QueryPlanHash, DatabaseName, UserName, ClientHostName, ClientAppName, BatchText_Statement, SqlText)
SELECT --eventstats.value('(action[@name="session_id"])[1]', 'bigint') as session_id
    eventstats.value('(/event/@name)[1]','nvarchar(200)') as event_name    
    , dateadd(hour,datediff(hour,getutcdate(),getdate()),eventstats.value('(/event/@timestamp)[1]','datetime')) as event_date
	, eventstats.value('(data[@name="cpu_time"])[1]', 'bigint') / 1000 as cpu_time_ms
	, eventstats.value('(data[@name="duration"])[1]', 'bigint') / 1000 as duration_ms
	, eventstats.value('(data[@name="physical_reads"])[1]', 'bigint') as physical_reads
	, eventstats.value('(data[@name="logical_reads"])[1]', 'bigint') as logical_reads
	, eventstats.value('(data[@name="writes"])[1]', 'bigint') as writes
	, eventstats.value('(data[@name="row_count"])[1]', 'bigint') as row_count
	, eventstats.value('(data[@name="result"]/text)[1]', 'nvarchar(256)') as result
    , eventstats.value('(action[@name="plan_handle"])[1]', 'int') as plan_handle
    , eventstats.value('(action[@name="query_hash"])[1]', 'int') as query_hash
    , eventstats.value('(action[@name="query_plan_hash"])[1]', 'int') as query_plan_hash
    , eventstats.value('(action[@name="database_name"])[1]', 'nvarchar(200)') as database_name
	, eventstats.value('(action[@name="username"])[1]', 'nvarchar(256)') as username
	, eventstats.value('(action[@name="client_hostname"])[1]', 'nvarchar(256)') as client_hostname
	, eventstats.value('(action[@name="client_app_name"])[1]', 'nvarchar(256)') as client_app_name
    , RTRIM
      (
        LTRIM
	    (
		    CASE
			    WHEN eventstats.value('(/event/@name)[1]','nvarchar(200)') IN ('rpc_completed', 'sql_statement_completed', 'sp_statement_completed')
				    THEN eventstats.value('(data[@name="statement"])[1]', 'nvarchar(max)')
			    WHEN eventstats.value('(/event/@name)[1]','nvarchar(200)') IN ('sql_batch_completed')  
				    THEN eventstats.value('(data[@name="batch_text"])[1]', 'nvarchar(max)')
			    ELSE 'Error'
		    END
	    )
      ) batch_text_statement
	, RTRIM(LTRIM(eventstats.value('(action[@name="sql_text"])[1]', 'nvarchar(max)'))) as sql_text
FROM
(
    SELECT CAST(event_data AS XML) AS event_xml
    --FROM sys.fn_xe_file_target_read_file(N'E:\Pass발표\XEFile\*.xel', null, null, null) -- 해당 폴더의 모든 xel파일
	FROM sys.fn_xe_file_target_read_file(N'E:\Pass발표\XEFile\Step3*.xel', null, null, null)
)  T CROSS APPLY event_xml.nodes('//event') AS x(eventstats)
ORDER BY event_date


SELECT *
FROM XEventTrace