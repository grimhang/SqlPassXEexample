CREATE EVENT SESSION [Step6_P_MAIN] ON SERVER 
 ADD EVENT sqlserver.rpc_completed
    (
        SET collect_statement=(1)
        ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)
        WHERE
            (
                    [sqlserver].[equal_i_sql_unicode_string]([object_name],N'P_Main')
					OR
					[sqlserver].[equal_i_sql_unicode_string]([object_name],N'P_Sub1')
					OR
					[sqlserver].[equal_i_sql_unicode_string]([object_name],N'P_Sub2')
            )
    )
, ADD EVENT sqlserver.sp_statement_completed
    (
        SET collect_object_name=(1),collect_statement=(1)
        ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)
        WHERE 
            (
                    [sqlserver].[equal_i_sql_unicode_string]([object_name],N'P_Main')
					OR
					[sqlserver].[equal_i_sql_unicode_string]([object_name],N'P_Sub1')
					OR
					[sqlserver].[equal_i_sql_unicode_string]([object_name],N'P_Sub2')
            )
    )
, ADD EVENT sqlserver.module_end
    (
        SET collect_statement=(1)
        ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)
        WHERE (
                [object_name]=N'P_Main')
               )
, ADD EVENT sqlserver.sql_batch_completed
    (
    SET collect_batch_text=(1)
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.username)
    WHERE 
        (
                [sqlserver].[like_i_sql_unicode_string]([batch_text],N'%P_Main%')
        )
    )
ADD TARGET package0.event_file(SET filename=N'E:\Pass발표\XEFile\P_Main_2021-11-15.xel')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO


-- ALTER EVENT SESSION [Step6_P_MAIN]       ON SERVER STATE = START;

-- ALTER EVENT SESSION [Step6_P_MAIN]       ON SERVER STATE = STOP;

-- DROP EVENT SESSION [Step6_P_MAIN]       ON SERVER 
/*
    -- active Xevent session
    SELECT *
    FROM sys.dm_xe_sessions
   
   -- all Xevent session
    SELECT *
    FROM sys.server_event_sessions      -- 온프레미스만
    ORDER BY name
*/

