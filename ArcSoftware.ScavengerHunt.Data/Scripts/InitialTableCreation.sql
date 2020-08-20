use scavenger_hunt
go

drop table if exists ApiLog
drop table if exists LogSeverity
drop table if exists LogType
drop table if exists UserGpsLog
drop table if exists UserDeviceLog
drop table if exists Platform
drop table if exists Challenge
drop table if exists Hunt
drop table if exists UserProfile
go

create table dbo.UserProfile (
	 id int identity(1,1) not null 
	,UserId varchar(20) not null
	,Email varchar(255) not null
	,IsActive bit not null default 1

	 constraint ak_Email unique nonclustered (Email)
	,constraint pk_UserKey primary key clustered (id asc)
)
go

create table dbo.Hunt (
	 id int identity(1,1) not null
	,HuntName varchar(20) not null
    ,CreateUserKey int foreign key references dbo.UserProfile (id) on delete cascade
    ,CreateDate datetime not null default getdate()
    ,LastLoadDate datetime null 
	,IsActive bit not null default 1

	,constraint pk_HuntKey primary key clustered (id asc)
)
go

create table dbo.Challenge (
	 id int identity(1,1) not null
	,ChallengeName varchar(50) not null
	,HuntKey int not null foreign key references dbo.Hunt (id)
    ,Hint1 varchar(255) not null
    ,Hint2 varchar(255) not null
	,SolutionText varchar(255) not null
	,SolutionQR varchar(255) null
    ,SolutionLat decimal(9,6) null
	,SolutionLong decimal(9,6) null
	,IsActive bit not null default 1
			 
	,constraint pk_ChallengeKey primary key clustered (id asc)
)
go

create table dbo.Platform (
	 id int identity(1,1)
	,PlatformDesc varchar(255)

constraint pk_PlatformKey primary key clustered (id asc)
)
go

create table dbo.UserDeviceLog (
	  id int identity (1,1) not null
	 ,UserKey int not null foreign key references dbo.UserProfile (id)
	 ,CreateDate datetime not null default getdate()
     ,LastConnectDate datetime not null default getdate()
	 ,LastLat decimal (9,6) not null
	 ,LastLong decimal (9,6) not null
     ,PlatformKey int foreign key references dbo.Platform (id) on delete cascade

	 constraint pk_DeviceLogKey primary key clustered (id asc)
)
go

create table dbo.UserGpsLog (
	  id int identity (1,1) not null
	 ,UserKey int not null foreign key references dbo.UserProfile (id)
	 ,GpsTimestamp datetime not null default getdate()
	 ,Latitude decimal (9,6) not null
	 ,Longitude decimal (9,6) not null

	 constraint pk_UserGPSLogKey primary key clustered (id asc)
)
go

create table dbo.LogType (
	 id int identity(1,1)
	,TypeDesc varchar(255)

constraint pk_LogTypeKey primary key clustered (id asc)
)
go

create table dbo.LogSeverity (
	 id int identity(1,1)
	,SeverityDesc varchar(255)

constraint pk_LogSeverityKey primary key clustered (id asc)
)
go

create table dbo.ApiLog (
	  id int identity (1,1) not null
     ,LogDate datetime not null default getdate()
     ,LogTypeKey int not null foreign key references dbo.LogType (id) on delete cascade
     ,SeverityKey int not null foreign key references dbo.LogSeverity (id) on delete cascade
     ,PlatformKey int not null foreign key references dbo.Platform (id) on delete cascade
     ,AppVersion varchar(20) null
     ,RouteDesc varchar(100) null
     ,UserKey int not null foreign key references dbo.UserProfile (id) on delete cascade
     ,LogMessage varchar(max) null

	 constraint pk_ApiLogKey primary key clustered (id asc)
)
go

--Data Load
insert into dbo.LogType values ('Info')
insert into dbo.LogType values ('Error')
insert into dbo.LogType values ('Security')

insert into dbo.LogSeverity values ('Info')
insert into dbo.LogSeverity values ('Warning')
insert into dbo.LogSeverity values ('Critical')

insert into dbo.Platform values ('Sql')
insert into dbo.Platform values ('Api')
insert into dbo.Platform values ('Web')
insert into dbo.Platform values ('iOS')
insert into dbo.Platform values ('Android')

insert into dbo.UserProfile values('System', 'SystemTest', 1)

grant execute on object:: dbo.spGet_ApiLogs to api_svc;
grant execute on object:: dbo.spPost_ApiLog to api_svc;
go