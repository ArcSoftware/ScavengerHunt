use scavenger_hunt
go

drop procedure if exists dbo.spGet_ApiLogs;
drop procedure if exists dbo.spPost_ApiLog;
go

create procedure dbo.spGet_ApiLogs (@StartDate DateTime, @EndDate DateTime) as 
	begin
		set nocount on;

		--declare @StartDate DateTime = null
		--declare @EndDate DateTime = null

		if @StartDate is null
			begin
				set @StartDate = convert(Datetime, floor(convert(float,getDate())))
				set @EndDate = convert(Datetime, ceiling(convert(float,getDate())))
			end

		select 
		   l.id
		  ,LogDate
		  ,t.TypeDesc [Type]
		  ,s.SeverityDesc [Severity]
		  ,p.PlatformDesc [Platform]
		  ,l.RouteDesc
		  ,AppVersion
		  ,u.id [UserKey]
		  ,u.UserId
		  ,LogMessage
		  from scavenger_hunt.dbo.ApiLog l
		  left join dbo.UserProfile u on l.UserKey = u.id
		  left join dbo.LogType t on l.LogTypeKey = t.id
		  left join dbo.LogSeverity s on l.SeverityKey = s.id
		  left join dbo.Platform p on l.PlatformKey = p.id
		  where l.LogDate >= @StartDate and l.LogDate <= @EndDate
		  order by 1 desc

		set nocount off;
	end
go

create procedure dbo.spPost_ApiLog (@logType int, @logSeverity int, @platform int, @routeDesc varchar(100), @appVersion varchar(20), @userKey int, @logMessage varchar(max)) as 
	begin
		set nocount on;

		declare 
		  @state bit = 1
		, @message nvarchar(max) = 'Log Successful';

		begin try
		    declare @offset nvarchar(12); 
		    declare @hh nvarchar(3);

		    set @offset = (select current_utc_offset 
					 from   sys.time_zone_info 
					 where  name = N'US Eastern Standard Time') 
		    set @hh = Substring(@offset, 1, 3); 

			insert into dbo.ApiLog
				   (LogDate
				   ,LogTypeKey
				   ,SeverityKey
				   ,PlatformKey
				   ,AppVersion
				   ,RouteDesc
				   ,UserKey
				   ,LogMessage)
			values 
					(Dateadd(hh, CONVERT(INT, @hh), Getutcdate())
					,@logType
					,@logSeverity
					,@platform
					,@routeDesc
					,@appVersion
					,@userKey
					,@logMessage)
		end try

		begin catch
			set @state = ERROR_STATE()
			set @message = (select 'ERROR_NUMBER: ' + convert(nvarchar,ERROR_NUMBER()) + ', ERROR_SEVERITY: ' + convert(nvarchar,ERROR_SEVERITY()) + ', ERROR_PROCEDURE: ' + convert(nvarchar,ERROR_PROCEDURE()) + ', ERROR_LINE: ' + convert(nvarchar,ERROR_LINE()) + ', ERROR_MESSAGE: ' + convert(nvarchar(500),ERROR_MESSAGE()));	
		end catch

		select @state [ErrorState], @message [ErrorMessage];

		set nocount off;
	end