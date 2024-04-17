


Drop Table if exists AgreementEquipment
Drop Table if exists Agreement
Drop Table if exists Client
Drop Table if exists EquipmentService 
Drop Table if exists Staff
Drop Table if exists Branch
Drop Table if exists Position
Drop Table if exists Service
Drop Table if exists Equipment
Drop Table if exists Condition
Drop Table if exists Supplier


Create Table Supplier (
SupplierID int not null identity (1,10) constraint pk_Supplier Primary Key,
Supplier varchar (64) not null

)

Create Table Condition (
cCode int not null identity (1,1) constraint pk_Condition Primary Key,
ConditionDescription varchar(32) not null
)

Create Table Equipment (
EquipmentNo int not null constraint pk_Equipment Primary Key,
Description varchar(225) not null,
DatePurchased date not null,
PurchasePrice money not null,
SupplierID int not null constraint fk_toSupplier references Supplier(SupplierID),
PurchasedNew bit not null,
cCode int not null constraint fk_toCondition references Condition(cCode),
PricePerDay smallmoney not null
)


Create Table Service (
ServiceTypeID int not null identity (1,1) constraint pk_Service Primary Key,
Description varchar(128) not null
)

Create Table Position (
PID smallint not null identity (1,1) constraint pk_Position Primary Key,
Position varchar(32) not null,
)


Create Table Branch(
BranchNo char(4) not null constraint pk_Branch Primary Key
constraint ck_validBranchNumber check (BranchNo like 'B[0-9][0-9]'),
BranchAddress varchar(128) not null,
City varchar(32) not null,
Province char(2) not null
constraint ck_validProvince check (Province = '[a-z][a-z]')
constraint df_defaultProvince default 'ab',
PostalCode char(7)not null
constraint ck_validPostalCode check(PostalCode like '[a-z][a-z][a-z] [a-z][a-z][a-z]'),
TelephoneNumber1 char(12) not null constraint ck_validPhoneNumber1 check (TelephoneNumber1 like '[1-9][0-9][0-9]-[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
TelephoneNumber2 char(12)  null constraint ck_validPhoneNumber2 check (TelephoneNumber2 like '[1-9][0-9][0-9]-[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
TelephoneNumber3 char(12)  null constraint ck_validPhoneNumber3 check (TelephoneNumber3 like '[1-9][0-9][0-9]-[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
)

Create Table Staff (
StaffNo char(8) not null constraint pk_Staff Primary Key,
--constraint ck_validStaffNumber check (StaffNo like 'S201[0-9][0-9][0-9]'),---
FirstName varchar(32) not null,
LastName varchar(32) not null,
StartDate date null constraint dk_StartNow default 'datetime',
PID smallint not null constraint fk_ToPosition references Position(PID),
Salary smallmoney null, 
HourlyRate smallmoney null,
Rate smallmoney null,
ManagerStartDate date null,
ManagerBonus smallmoney null,
Supervisor char(8) null,
BranchNo char(4) not null constraint fk_ToBranch references Branch(BranchNo),
constraint ck_nullValue check(Salary = null or HourlyRate = null)
)

Create Table EquipmentService (
ServiceID int not null,
EquipmentNo int not null constraint fk_ToEquipment references Equipment(EquipmentNo),
ServiceDate smalldatetime not null,
ServiceTypeID int null constraint fk_ToService references Service(ServiceTypeID),
Comments varchar(225),
StaffNo char (8) null constraint fk_ToStaff references Staff(StaffNo),
constraint pk_EquipmentService Primary Key (ServiceId, EquipmentNo)
)


Create Table Client (
ClientNo int not null identity (1,1) constraint pk_Client Primary Key,
FirstName varchar(32) not null,
LastName varchar(32) not null,
PhoneNumber char(12) not null
constraint ck_validPhoneNumber check (PhoneNumber like '[1-9][0-9][0-9]-[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
)

Create Table Agreement (
AgreementNo int not null identity (1,1) constraint pk_Agreement Primary Key,
ClientNo int not null constraint fk_toclient references Client(ClientNo),
TotalGst smallmoney not null,
Total money not null
)

Create Table AgreementEquipment (
AgreementNo int not null constraint fk_toAgreement references Agreement(AgreementNo),
EquipmentNo int not null, 
Rentstartdate date not null,
Rentenddate date not null, 
DaysRented int not null,
PricePerDay smallmoney not null,
ExtendedPrice money not null,
Gst smallmoney not null
constraint pk_AgreementEquipment Primary Key(AgreementNo, EquipmentNo)

)

Alter Table Equipment
ADD 
constraint df_PurchasedNew
default '1' for PurchasedNew

Alter Table Client
Add
EmailAddress varchar(32) null
constraint ck_validEmail check (EmailAddress like '___@%.__')
Create nonclustered index IX_Equipment_SupplierID on Equipment(SupplierID)
Create nonclustered index IX_EquipmentcCode on Equipment(cCode)
Create nonclustered index IX_Staff_PID on Staff(PID)
Create nonclustered index IX_StaffBranchNo on Staff(BranchNo)
Create nonclustered index IX_EquipmentService_EquipmentNo on EquipmentService(EquipmentNo)
Create nonclustered index IX_EquipmentService_ServiceTypeID on EquipmentService(ServiceTypeID)
Create nonclustered index IX_EquipmentServiceStaffNo on EquipmentService(StaffNo)
Create nonclustered index IX_AgreementClientNo on Agreement(Clientno)
Create nonclustered index IX_AgreementEquipment on AgreementEquipment(AgreementNo)


---  Comments
--known error : I could not get some of the test data to work: the insert statements for Branch, Staff and EquipmentService tables
--did not work for me. Something to do with the foreign keys. I tried to tinker with this but to no avail. 
	
--
--The lab was good. I felt that the videos and exercises that my instructor provided on Moodle were great. Easy to follow
--and great explanations. The lab didn't take too long to complete and I felt that the material thoroughly prepared me
--for this lab. One suggestion, can there be a quick vid about using test data? I just want to make sure I am doing it properly 