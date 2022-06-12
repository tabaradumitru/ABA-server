create table activity
(
    ActivityId      int auto_increment
        primary key,
    ActivityName    varchar(50)       not null,
    RequiresLicense tinyint default 0 not null,
    constraint activity_Name_uindex
        unique (ActivityName)
);

create table area
(
    AreaId   int auto_increment
        primary key,
    AreaName varchar(50) not null
);

create table citizen
(
    CitizenIDNP varchar(13) not null
        primary key,
    FirstName   varchar(50) not null,
    LastName    varchar(50) not null,
    constraint Citizen_CitizenIDNP_uindex
        unique (CitizenIDNP)
);

create table district
(
    DistrictId   int auto_increment
        primary key,
    DistrictName varchar(50) not null,
    AreaId       int         not null,
    constraint district_area_AreaId_fk
        foreign key (AreaId) references area (AreaId)
);

create table employee_title
(
    EmployeeTitleId int auto_increment
        primary key,
    Name            varchar(50) not null
);

create table employee
(
    EmployeeIDNP    varchar(13) not null
        primary key,
    EmployeeTitleId int         not null,
    PoliceSectorId  int         not null,
    FirstName       varchar(50) not null,
    LastName        varchar(50) not null,
    IsActive        tinyint     not null,
    constraint employee_employee_title_EmployeeTitleId_fk
        foreign key (EmployeeTitleId) references employee_title (EmployeeTitleId)
);

create table license_status
(
    StatusId   int auto_increment
        primary key,
    StatusName varchar(50) not null
);

create table locality
(
    LocalityId   int auto_increment
        primary key,
    LocalityName varchar(50) not null,
    DistrictId   int         not null,
    constraint locality_district_DistrictId_fk
        foreign key (DistrictId) references district (DistrictId)
);

create table receiving_method
(
    ReceivingMethodId   int auto_increment
        primary key,
    ReceivingMethodName varchar(255)      null,
    IsRequired          tinyint default 0 not null
);

create table regional_direction
(
    RegionalDirectionId   int auto_increment
        primary key,
    AreaId                int          not null,
    RegionalDirectionName varchar(255) not null,
    constraint regional_direction_area_AreaId_fk
        foreign key (AreaId) references area (AreaId)
);

create table police_sector
(
    PoliceSectorId      int auto_increment
        primary key,
    PoliceSectorName    varchar(50) not null,
    RegionalDirectionId int         not null,
    constraint police_sector_regional_direction_RegionalDirectionId_fk
        foreign key (RegionalDirectionId) references regional_direction (RegionalDirectionId)
);

create table request_status
(
    StatusId   int auto_increment
        primary key,
    StatusName varchar(20) not null
);

create table request
(
    RequestId    int auto_increment
        primary key,
    CitizenIDNP  varchar(50)       not null,
    ActivityId   int               not null,
    StartDate    date              not null,
    EndDate      date              not null,
    CreatedAt    date              not null,
    StatusId     int               not null,
    Note         varchar(2000)     null,
    NotifyExpiry tinyint default 0 not null,
    constraint request_activity_RequestId_fk
        foreign key (ActivityId) references activity (ActivityId),
    constraint request_citizen_CitizenIDNP_fk
        foreign key (CitizenIDNP) references citizen (CitizenIDNP),
    constraint request_request_status_StatusId_fk
        foreign key (StatusId) references request_status (StatusId)
);

create table license
(
    LicenseId     int auto_increment
        primary key,
    RequestId     int               not null,
    EmployeeIDNP  varchar(13)       not null,
    LicenseNumber varchar(20)       not null,
    CreatedAt     date              not null,
    CitizenIDNP   varchar(13)       not null,
    ActivityId    int               not null,
    StartDate     date              not null,
    EndDate       date              not null,
    StatusId      int     default 1 not null,
    NotifyExpiry  tinyint default 0 not null,
    Note          varchar(2000)     null,
    constraint license_LicenseNumber_uindex
        unique (LicenseNumber),
    constraint license_activity_ActivityId_fk
        foreign key (ActivityId) references activity (ActivityId),
    constraint license_citizen_CitizenIDNP_fk
        foreign key (CitizenIDNP) references citizen (CitizenIDNP),
    constraint license_employee_EmployeeIDNP_fk
        foreign key (EmployeeIDNP) references employee (EmployeeIDNP),
    constraint license_license_status_StatusId_fk
        foreign key (StatusId) references license_status (StatusId),
    constraint license_request_RequestId_fk
        foreign key (RequestId) references request (RequestId)
);

create table license_locality
(
    Id         int auto_increment
        primary key,
    LicenseId  int not null,
    LocalityId int not null,
    constraint license_locality_license_LicenseId_fk
        foreign key (LicenseId) references license (LicenseId),
    constraint license_locality_locality_LocalityId_fk
        foreign key (LocalityId) references locality (LocalityId)
);

create table license_receiving_method
(
    Id                   int auto_increment
        primary key,
    LicenseId            int          not null,
    ReceivingMethodId    int          not null,
    ReceivingMethodValue varchar(255) not null,
    constraint license_receiving_method_license_LicenseId_fk
        foreign key (LicenseId) references license (LicenseId),
    constraint license_receiving_method_receiving_method_ReceivingMethodId_fk
        foreign key (ReceivingMethodId) references receiving_method (ReceivingMethodId)
);

create table request_locality
(
    Id         int auto_increment
        primary key,
    RequestId  int not null,
    LocalityId int not null,
    constraint request_locality_locality_LocalityId_fk
        foreign key (LocalityId) references locality (LocalityId),
    constraint request_locality_request_RequestId_fk
        foreign key (RequestId) references request (RequestId)
);

create table request_receiving_method
(
    Id                   int auto_increment
        primary key,
    RequestId            int          not null,
    ReceivingMethodId    int          not null,
    ReceivingMethodValue varchar(255) null,
    constraint request_receiving_method_receiving_method_ReceivingMethodId_fk
        foreign key (ReceivingMethodId) references receiving_method (ReceivingMethodId),
    constraint request_receiving_method_request_RequestId_fk
        foreign key (RequestId) references request (RequestId)
);

create table validation_type
(
    ValidationTypeId   int auto_increment
        primary key,
    ValidationTypeName varchar(255) not null
);

create table mconnect_validation
(
    MconnectValidationId int auto_increment
        primary key,
    RequestId            int           not null,
    ValidationTypeId     int           not null,
    ValidationValue      varchar(1000) not null,
    constraint mconnect_validation_request_RequestId_fk
        foreign key (RequestId) references request (RequestId),
    constraint mconnect_validation_validation_type_ValidationTypeId_fk
        foreign key (ValidationTypeId) references validation_type (ValidationTypeId)
);



INSERT INTO aba.activity (ActivityId, ActivityName, RequiresLicense) VALUES (2, 'Odihnă', 0);
INSERT INTO aba.activity (ActivityId, ActivityName, RequiresLicense) VALUES (3, 'Vânătoare', 1);
INSERT INTO aba.activity (ActivityId, ActivityName, RequiresLicense) VALUES (4, 'Pescuit', 1);

INSERT INTO aba.area (AreaId, AreaName) VALUES (1, 'Nord');
INSERT INTO aba.area (AreaId, AreaName) VALUES (2, 'Sud');
INSERT INTO aba.area (AreaId, AreaName) VALUES (3, 'Vest (Prut)');
INSERT INTO aba.area (AreaId, AreaName) VALUES (4, 'Est (Nistru)');

INSERT INTO aba.citizen (CitizenIDNP, FirstName, LastName) VALUES ('1000000000000', 'Ion', 'Donica');
INSERT INTO aba.citizen (CitizenIDNP, FirstName, LastName) VALUES ('2000000000000', 'Dumitru', 'Tabără');
INSERT INTO aba.citizen (CitizenIDNP, FirstName, LastName) VALUES ('3000000000000', 'Tony-Mark', 'Zelenkov');

INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (1, 'Florești', 4);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (2, 'Soroca', 4);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (3, 'Dondușeni', 1);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (4, 'Ocnița', 1);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (5, 'Edineț', 1);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (6, 'Briceni', 1);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (7, 'Rîșcani', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (8, 'Glodeni', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (9, 'Fălești', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (10, 'Ungheni', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (11, 'Nisporeni', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (12, 'Hîncești', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (13, 'Leova', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (14, 'Cantemir', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (15, 'Cahul', 3);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (16, 'UTA Găgăuzia', 2);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (17, 'Taraclia', 2);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (18, 'Basarabeasca', 2);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (19, 'Cimișlia', 2);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (20, 'Ștefan Vodă', 2);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (21, 'UAT Stânga Nistrului', 4);
INSERT INTO aba.district (DistrictId, DistrictName, AreaId) VALUES (22, 'Căușeni', 2);

INSERT INTO aba.employee (EmployeeIDNP, EmployeeTitleId, PoliceSectorId, FirstName, LastName, IsActive) VALUES ('4000000000000', 1, 2, 'Veaceslav', 'Scurtu', 1);

INSERT INTO aba.employee_title (EmployeeTitleId, Name) VALUES (1, 'Ofițer');

INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (2, 8, '4000000000000', 'PA-000000001', '2021-04-09', '2000000000000', 4, '2021-04-14', '2021-04-29', 2, 0, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (5, 12, '4000000000000', 'PA-000000002', '2021-04-10', '2000000000000', 4, '2021-04-19', '2021-04-22', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (6, 9, '4000000000000', 'PA-000000003', '2021-04-10', '2000000000000', 3, '2021-04-21', '2021-04-22', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (7, 11, '4000000000000', 'PA-000000004', '2021-04-10', '2000000000000', 3, '2021-04-18', '2021-04-21', 3, 0, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (8, 7, '4000000000000', 'PA-000000005', '2021-04-10', '2000000000000', 2, '2021-03-14', '2021-03-15', 2, 0, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (9, 13, '4000000000000', 'PA-000000006', '2021-04-11', '2000000000000', 3, '2021-04-11', '2021-04-21', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (10, 14, '4000000000000', 'PA-000000007', '2021-04-11', '2000000000000', 2, '2021-04-06', '2021-04-15', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (11, 5, '4000000000000', 'PA-000000008', '2021-04-11', '2000000000000', 2, '2021-03-08', '2021-03-09', 2, 0, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (12, 15, '4000000000000', 'PA-000000009', '2021-04-11', '2000000000000', 2, '2021-04-18', '2021-04-21', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (13, 10, '4000000000000', 'PA-000000010', '2021-04-11', '2000000000000', 4, '2021-04-04', '2021-04-15', 2, 0, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (14, 1, '4000000000000', 'PA-000000011', '2021-04-11', '2000000000000', 2, '2021-03-07', '2021-03-15', 2, 0, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (15, 16, '4000000000000', 'PA-000000012', '2021-04-11', '2000000000000', 2, '2021-04-13', '2021-04-21', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (16, 17, '4000000000000', 'PA-000000013', '2021-04-11', '2000000000000', 3, '2021-04-11', '2021-04-13', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (17, 18, '4000000000000', 'PA-000000014', '2021-04-11', '2000000000000', 4, '2021-04-11', '2021-04-13', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (18, 20, '4000000000000', 'PA-000000015', '2021-04-11', '2000000000000', 3, '2021-04-19', '2021-04-20', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (19, 19, '4000000000000', 'PA-000000016', '2021-04-11', '2000000000000', 2, '2021-04-13', '2021-04-21', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (20, 21, '4000000000000', 'PA-000000017', '2021-04-11', '2000000000000', 2, '2021-04-13', '2021-04-14', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (21, 23, '4000000000000', 'PA-000000018', '2021-04-11', '2000000000000', 2, '2021-04-14', '2021-04-16', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (22, 24, '4000000000000', 'PA-000000019', '2021-04-11', '2000000000000', 2, '2021-04-14', '2021-04-16', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (23, 25, '4000000000000', 'PA-000000020', '2021-04-11', '2000000000000', 4, '2021-04-12', '2021-04-14', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (24, 22, '4000000000000', 'PA-000000021', '2021-04-11', '2000000000000', 2, '2021-04-11', '2021-04-13', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (25, 26, '4000000000000', 'PA-000000022', '2021-04-12', '2000000000000', 2, '2021-04-14', '2021-04-16', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (26, 27, '4000000000000', 'PA-000000023', '2021-04-12', '2000000000000', 2, '2021-04-14', '2021-04-14', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (27, 30, '4000000000000', 'PA-000000024', '2021-04-14', '2000000000000', 4, '2021-04-20', '2021-04-22', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (28, 28, '4000000000000', 'PA-000000025', '2021-04-14', '2000000000000', 2, '2021-04-16', '2021-04-20', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (29, 29, '4000000000000', 'PA-000000026', '2021-04-14', '2000000000000', 3, '2021-04-16', '2021-04-20', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (30, 31, '4000000000000', 'PA-000000027', '2021-04-15', '2000000000000', 4, '2021-04-22', '2021-04-24', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (31, 32, '4000000000000', 'PA-000000028', '2021-04-15', '2000000000000', 4, '2021-04-16', '2021-04-19', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (32, 33, '4000000000000', 'PA-000000029', '2021-05-13', '2000000000000', 2, '2021-05-20', '2021-05-22', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (33, 6, '4000000000000', 'PA-000000030', '2021-05-13', '2000000000000', 2, '2021-03-07', '2021-03-08', 2, 0, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (34, 34, '4000000000000', 'PA-000000031', '2021-05-13', '2000000000000', 2, '2021-05-20', '2021-05-21', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (35, 35, '4000000000000', 'PA-000000032', '2021-05-17', '2000000000000', 4, '2021-05-20', '2021-05-22', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (36, 37, '4000000000000', 'PA-000000033', '2021-06-08', '2000000000000', 2, '2021-06-10', '2021-06-11', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (37, 38, '4000000000000', 'PA-000000034', '2021-06-08', '2000000000000', 2, '2021-06-10', '2021-06-11', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (38, 39, '4000000000000', 'PA-000000035', '2021-06-09', '2000000000000', 2, '2021-06-11', '2021-06-12', 2, 1, null);
INSERT INTO aba.license (LicenseId, RequestId, EmployeeIDNP, LicenseNumber, CreatedAt, CitizenIDNP, ActivityId, StartDate, EndDate, StatusId, NotifyExpiry, Note) VALUES (39, 40, '4000000000000', 'PA-000000036', '2021-06-09', '2000000000000', 2, '2021-06-10', '2021-06-10', 2, 1, null);

INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (1, 2, 104);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (2, 2, 105);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (3, 2, 123);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (4, 2, 147);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (5, 2, 148);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (11, 5, 497);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (12, 5, 496);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (13, 6, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (14, 6, 179);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (15, 6, 180);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (16, 7, 259);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (17, 7, 258);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (18, 8, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (19, 8, 165);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (20, 8, 170);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (21, 8, 171);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (22, 9, 170);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (23, 10, 241);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (24, 10, 242);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (25, 11, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (26, 11, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (27, 11, 170);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (28, 11, 171);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (29, 12, 110);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (30, 12, 111);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (31, 13, 242);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (32, 14, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (33, 14, 171);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (34, 15, 333);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (35, 15, 334);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (36, 15, 335);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (37, 15, 336);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (38, 16, 429);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (39, 16, 430);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (40, 17, 340);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (41, 17, 339);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (42, 17, 341);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (43, 18, 430);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (44, 19, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (45, 19, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (46, 20, 241);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (47, 20, 242);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (48, 21, 450);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (49, 21, 451);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (50, 21, 452);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (51, 22, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (52, 22, 165);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (53, 23, 270);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (54, 23, 277);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (55, 23, 167);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (56, 23, 168);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (57, 23, 174);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (58, 23, 176);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (59, 23, 264);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (60, 23, 275);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (61, 23, 187);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (62, 23, 241);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (63, 23, 242);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (64, 23, 250);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (65, 23, 251);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (66, 23, 262);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (67, 23, 186);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (68, 23, 185);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (69, 23, 263);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (70, 23, 400);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (71, 23, 374);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (72, 23, 286);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (73, 23, 288);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (74, 23, 294);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (75, 23, 293);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (76, 23, 292);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (77, 23, 399);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (78, 23, 278);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (79, 23, 375);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (80, 23, 382);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (81, 23, 389);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (82, 23, 391);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (83, 23, 397);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (84, 23, 396);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (85, 23, 271);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (86, 23, 381);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (87, 23, 272);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (88, 24, 429);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (89, 25, 241);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (90, 25, 242);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (91, 25, 257);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (92, 25, 258);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (93, 25, 104);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (94, 25, 105);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (95, 25, 109);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (96, 25, 110);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (97, 25, 111);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (98, 26, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (99, 26, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (100, 27, 332);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (101, 27, 336);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (102, 27, 337);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (103, 28, 332);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (104, 28, 333);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (105, 28, 334);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (106, 29, 339);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (107, 29, 340);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (108, 29, 341);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (109, 30, 336);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (110, 30, 337);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (111, 30, 338);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (112, 30, 241);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (113, 30, 242);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (114, 30, 243);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (115, 31, 333);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (116, 31, 334);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (117, 31, 335);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (118, 32, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (119, 32, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (120, 32, 328);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (121, 32, 329);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (122, 33, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (123, 33, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (124, 33, 170);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (125, 33, 171);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (126, 34, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (127, 34, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (128, 34, 172);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (129, 34, 173);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (130, 35, 347);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (131, 35, 348);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (132, 36, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (133, 36, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (134, 36, 241);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (135, 36, 242);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (136, 37, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (137, 37, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (138, 37, 193);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (139, 37, 192);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (140, 37, 241);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (141, 37, 242);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (142, 38, 341);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (143, 38, 342);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (144, 38, 343);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (145, 39, 163);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (146, 39, 164);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (147, 39, 170);
INSERT INTO aba.license_locality (Id, LicenseId, LocalityId) VALUES (148, 39, 171);

INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (1, 2, 1, '12342342');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (3, 5, 1, '21341234');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (4, 6, 1, '23421341');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (5, 7, 1, '12341234');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (6, 8, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (7, 9, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (8, 10, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (9, 11, 1, '79335577');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (10, 12, 1, '21341234');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (11, 12, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (12, 13, 1, '12341234');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (13, 14, 1, '79335553');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (14, 14, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (15, 15, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (16, 15, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (17, 16, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (18, 16, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (19, 17, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (20, 17, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (21, 18, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (22, 18, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (23, 19, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (24, 19, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (25, 20, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (26, 20, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (27, 21, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (28, 21, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (29, 22, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (30, 22, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (31, 23, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (32, 23, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (33, 24, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (34, 24, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (35, 25, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (36, 25, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (37, 26, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (38, 26, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (39, 27, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (40, 27, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (41, 28, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (42, 28, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (43, 29, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (44, 29, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (45, 30, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (46, 30, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (47, 31, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (48, 31, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (49, 32, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (50, 32, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (51, 33, 1, '75464565');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (52, 34, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (53, 34, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (54, 35, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (55, 35, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (56, 36, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (57, 36, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (58, 37, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (59, 37, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (60, 38, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (61, 38, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (62, 39, 1, '79325262');
INSERT INTO aba.license_receiving_method (Id, LicenseId, ReceivingMethodId, ReceivingMethodValue) VALUES (63, 39, 2, 'dumitru12345@gmail.com');

INSERT INTO aba.license_status (StatusId, StatusName) VALUES (1, 'Activ');
INSERT INTO aba.license_status (StatusId, StatusName) VALUES (2, 'Expirat');
INSERT INTO aba.license_status (StatusId, StatusName) VALUES (3, 'Anulat');

INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (104, 'Napadova', 1);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (105, 'Temeleuţi', 1);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (106, 'Tîrgul Vertiujeni', 1);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (107, 'Vertiujeni', 1);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (108, 'Zăluceni', 1);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (109, 'Alexandru cel Bun', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (110, 'Balinţi', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (111, 'Balinţii Noi', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (112, 'Bădiceni', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (113, 'Cerlina', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (114, 'Cremenciug', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (115, 'Cosăuţi', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (116, 'Cureşniţa', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (117, 'Cureşniţa Nouă', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (118, 'Dărcăuţii Noi', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (119, 'Decebal', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (120, 'Dărcăuți', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (121, 'Egoreni', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (122, 'Grigorăuca', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (123, 'Holoşniţa', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (124, 'Hristici', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (125, 'Inundeni', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (126, 'Iarova', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (127, 'Iorjniţa', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (128, 'Livezi', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (129, 'Nimereuca', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (130, 'Niorcani', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (131, 'Oclanda', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (132, 'Ocolina', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (133, 'Parcani', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (134, 'Pîrlița', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (135, 'Racovăţ', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (136, 'Redi-Cereşnovăţ', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (137, 'Rubleniţa', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (138, 'Rubleniţa Nouă', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (139, 'Rudi', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (140, 'Ruslanovca', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (141, 'Slobozia Nouă', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (142, 'Slobozia-Vărăncău', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (143, 'Sobari', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (144, 'Soloneţ', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (145, 'Stoicani', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (146, 'Şeptelici', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (147, 'Şolcani', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (148, 'Slobozia-Cremene', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (149, 'Tătărăuca Nouă', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (150, 'Tătărăuca Veche', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (151, 'Tolocăneşti', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (152, 'Trifăuţi', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (153, 'Ţepilova', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (154, 'Valea', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (155, 'Vasilcău', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (156, 'Vanțina', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (157, 'Vărăncău', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (158, 'Visoca', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (159, 'Voloave', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (160, 'Voloviţa', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (161, 'Zastînca', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (162, 'Soroca', 2);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (163, 'Arioneşti', 3);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (164, 'Briceni', 3);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (165, 'Crişcăuţi', 3);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (166, 'Pocrovca', 3);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (167, 'Sudarca', 3);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (168, 'Teleşeuca', 3);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (169, 'Teleşeuca Nouă', 3);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (170, 'Frunză', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (171, 'Ocniţa', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (172, 'Otaci', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (173, 'Berezovca', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (174, 'Bîrnova', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (175, 'Calaraşovca', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (176, 'Clocuşna', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (177, 'Codreni', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (178, 'Corestăuţi', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (179, 'Dînjeni', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (180, 'Gîrbova', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (181, 'Hădărăuţi', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (182, 'Lencăuţi', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (183, 'Lipnic', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (184, 'Maiovca', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (185, 'Mereşeuca', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (186, 'Mihălăşeni', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (187, 'Naslavcea', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (188, 'Ocniţa', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (189, 'Sauca', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (190, 'Stălineşti', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (191, 'Unguri', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (192, 'Vălcineţ', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (193, 'Verejeni', 4);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (194, 'Bădragii Noi', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (195, 'Bădragii Vechi', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (196, 'Brînzeni', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (197, 'Burlăneşti', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (198, 'Buzdugeni', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (199, 'Cepeleuţi', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (200, 'Corpaci', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (201, 'Cuconeştii Noi', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (202, 'Cuconeştii Vechi', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (203, 'Feteşti', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (204, 'Hancăuţi', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (205, 'Lopatnic', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (206, 'Rîngaci', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (207, 'Terebna', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (208, 'Trinca', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (209, 'Vancicăuţi', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (210, 'Viişoara', 5);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (211, 'Briceni', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (212, 'Lipcani', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (213, 'Balasineşti', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (214, 'Bălcăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (215, 'Beleavinţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (216, 'Berlinţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (217, 'Bezeda', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (218, 'Bocicăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (219, 'Bogdăneşti', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (220, 'Bulboaca', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (221, 'Caracuşenii Noi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (222, 'Colicăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (223, 'Coteala', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (224, 'Cotiujeni', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (225, 'Criva', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (226, 'Drepcăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (227, 'Grimăncăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (228, 'Grimeşti', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (229, 'Hlina', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (230, 'Larga', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (231, 'Mărcăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (232, 'Mărcăuţii Noi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (233, 'Medveja', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (234, 'Pavlovca', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (235, 'Pererita', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (236, 'Slobozia-Medveja', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (237, 'Slobozia-Şirăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (238, 'Şirăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (239, 'Teţcani', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (240, 'Trebisăuţi', 6);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (241, 'Costeşti', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (242, 'Avrămeni', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (243, 'Branişte', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (244, 'Dămăşcani', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (245, 'Dumeni', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (246, 'Duruitoarea', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (247, 'Duruitoarea Nouă', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (248, 'Gălăşeni', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (249, 'Horodişte', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (250, 'Mălăieşti', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (251, 'Păşcăuţi', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (252, 'Petruşeni', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (253, 'Proscureni', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (254, 'Reteni', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (255, 'Reteni-Vasileuţi', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (256, 'Văratic', 7);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (257, 'Balatina', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (258, 'Bisericani', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (259, 'Brînzeni', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (260, 'Buteşti', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (261, 'Camenca', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (262, 'Ciuciulea', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (263, 'Clococenii Vechi', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (264, 'Cobani', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (265, 'Cot', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (266, 'Cuhneşti', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (267, 'Movileni', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (268, 'Lipovăţi', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (269, 'Moara Domnească', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (270, 'Moleşti', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (271, 'Serghieni', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (272, 'Tomeştii Noi', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (273, 'Tomeştii Vechi', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (274, 'Viişoara', 8);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (275, 'Bocşa', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (276, 'Călineşti', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (277, 'Chetriş', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (278, 'Chetrişul Nou', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (279, 'Cuzmenii Vechi', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (280, 'Drujineni', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (281, 'Hînceşti', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (282, 'Horeşti', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (283, 'Hrubna Nouă', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (284, 'Izvoare', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (285, 'Lucăceni', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (286, 'Musteaţa', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (287, 'Năvîrneţ', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (288, 'Pruteni', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (289, 'Rediul de Jos', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (290, 'Rediul de Sus', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (291, 'Risipeni', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (292, 'Taxobeni', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (293, 'Socii Noi', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (294, 'Unteni', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (295, 'Valea Rusului', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (296, 'Vrăneşti', 9);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (297, 'Ungheni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (298, 'Blindeşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (299, 'Buciumeni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (300, 'Buzduganii de Jos', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (301, 'Buzduganii de Sus', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (302, 'Cetireni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (303, 'Cioropcani', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (304, 'Chirileni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (305, 'Costuleni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (306, 'Elizavetovca', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (307, 'Floreni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (308, 'Floreşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (309, 'Floriţoaia Nouă', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (310, 'Floriţoaia Veche', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (311, 'Frăsineşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (312, 'Gherman', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (313, 'Grăseni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (314, 'Grozasca', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (315, 'Măcăreşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (316, 'Mănoileşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (317, 'Medeleni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (318, 'Morenii Noi', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (319, 'Morenii Vechi', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (320, 'Novaia Nicolaevca', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (321, 'Petreşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (322, 'Rezina', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (323, 'Sculeni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (324, 'Semeni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (325, 'Stolniceni', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (326, 'Şicovăţ', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (327, 'Todireşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (328, 'Unţeşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (329, 'Valea Mare', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (330, 'Vulpeşti', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (331, 'Zagarancea', 10);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (332, 'Băcşeni', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (333, 'Bălăureşti', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (334, 'Bărboieni', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (335, 'Brătuleni', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (336, 'Călimăneşti', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (337, 'Chilişoaia', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (338, 'Drojdieni', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (339, 'Grozeşti', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (340, 'Heleşteni', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (341, 'Isăicani', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (342, 'Luminiţa', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (343, 'Marinici', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (344, 'Odaia', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (345, 'Odobeşti', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (346, 'Selişteni', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (347, 'Soltăneşti', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (348, 'Şişcani', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (349, 'Valea-Trestieni', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (350, 'Zberoaia', 11);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (351, 'Călmăţui', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (352, 'Căţeleni', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (353, 'Cioara', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (354, 'Costeşti', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (355, 'Cotul Morii', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (356, 'Dancu', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (357, 'Feteasca', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (358, 'Frasin', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (359, 'Horjeşti', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (360, 'Ivanovca', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (361, 'Leuşeni', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (362, 'Marchet', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (363, 'Mingir', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (364, 'Nemţeni', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (365, 'Obileni', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (366, 'Pogăneşti', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (367, 'Sărăteni', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (368, 'Semionovca', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (369, 'Tălăieşti', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (370, 'Voinescu', 12);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (371, 'Leova', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (372, 'Cupcui', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (373, 'Filipeni', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (374, 'Hănăşenii Noi', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (375, 'Nicolaevca', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (376, 'Romanovca', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (377, 'Sărata-Răzeşti', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (378, 'Sîrma', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (379, 'Tochile-Răducani', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (380, 'Tomai', 13);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (381, 'Cantemir', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (382, 'Antoneşti', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (383, 'Cania', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (384, 'Ciobalaccia', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (385, 'Constantineşti', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (386, 'Flocoasa', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (387, 'Ghioltosu', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (388, 'Goteşti', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (389, 'Hîrtop', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (390, 'Hănăseni', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (391, 'Iepureni', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (392, 'Lărguţa', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (393, 'Leca', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (394, 'Plopi', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (395, 'Porumbeşti', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (396, 'Stoianovca', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (397, 'Taraclia', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (398, 'Ţiganca', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (399, 'Ţiganca Nouă', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (400, 'Toceni', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (401, 'Vîlcele', 14);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (402, 'Cahul', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (403, 'Alexandru Ioan Cuza', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (404, 'Andruşul de Jos', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (405, 'Badicul Moldovenesc', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (406, 'Brînza', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (407, 'Burlăceni', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (408, 'Chircani', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (409, 'Cîşliţa-Prut', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (410, 'Colibaşi', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (411, 'Cotihana', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (412, 'Crihana Veche', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (413, 'Cucoara', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (414, 'Giurgiuleşti', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (415, 'Greceni', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (416, 'Iujnoe', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (417, 'Larga Nouă', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (418, 'Larga Veche', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (419, 'Manta', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (420, 'Paicu', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (421, 'Paşcani', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (422, 'Roşu', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (423, 'Slobozia Mare', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (424, 'Tătăreşti', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (425, 'Treteşti', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (426, 'Vadul lui Isac', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (427, 'Văleni', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (428, 'Zîrneşti', 15);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (429, 'Vulcănești', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (430, 'Ceadîr-Lunga', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (431, 'Avdarma', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (432, 'Beşghioz', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (433, 'Cazaclia', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (434, 'Cişmichioi', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (435, 'Chiriet-Lunga', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (436, 'Copceac', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (437, 'Etulia', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (438, 'Etulia Nouă', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (439, 'Vulcăneşti', 16);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (440, 'Taraclia', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (441, 'Tvardița', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (442, 'Cairaclia', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (443, 'Chirilovca', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (444, 'Ciumai', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (445, 'Corten', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (446, 'Mirnoe', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (447, 'Musaitu', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (448, 'Valea Perjei', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (449, 'Vinogradovca', 17);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (450, 'Basarabeasca', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (451, 'Abaclia', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (452, 'Bogdanovca', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (453, 'Carabetovca', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (454, 'Carabiber', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (455, 'Iordanovca', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (456, 'Iserlia', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (457, 'Ivanovca', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (458, 'Sadaclia', 18);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (459, 'Batîr', 19);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (460, 'Bogdanovca Nouă', 19);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (461, 'Bogdanovca Veche', 19);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (462, 'Mihailovca', 19);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (463, 'Troiţcoe', 19);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (464, 'Baimaclia', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (465, 'Opaci', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (466, 'Sălcuţa', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (467, 'Sălcuța Nouă', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (468, 'Săiţi', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (469, 'Taraclia', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (470, 'Tocuz', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (471, 'Ucrainca', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (472, 'Zaim', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (473, 'Zviozdocica', 22);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (474, 'Ștefan-Vodă', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (475, 'Alava', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (476, 'Antoneşti', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (477, 'Brezoaia', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (478, 'Carahasani', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (479, 'Căplani', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (480, 'Copceac', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (481, 'Crocmaz', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (482, 'Feşteliţa', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (483, 'Lazo', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (484, 'Marianca de Jos', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (485, 'Olăneşti', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (486, 'Palanca', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (487, 'Purcari', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (488, 'Răscăieți', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (489, 'Răscăieții Noi', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (490, 'Semionovca', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (491, 'Slobozia', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (492, 'Ştefăneşti', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (493, 'Tudora', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (494, 'Volintiri', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (495, 'Viișoara', 20);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (496, 'Tiraspol', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (497, 'Camera', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (498, 'Crasnoe (Slobozia)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (499, 'Dnestrovsc', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (500, 'Maiac', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (501, 'Tiraspolul Nou', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (502, 'Afanasievca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (503, 'Alexandrovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (504, 'Alexandrovca Nouă', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (505, 'Andreevca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (506, 'Andriaşevca Nouă', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (507, 'Andriaşevca Veche', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (508, 'Basarabca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (509, 'Beloci', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (510, 'Bîcioc', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (511, 'Blijnii Hutor', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (512, 'Bodeni', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (513, 'Bosca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (514, 'Broşteni', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (515, 'Bruslachi', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (516, 'Buschi', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (517, 'Butor', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (518, 'Butuceni', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (519, 'Calinovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (520, 'Caragaş', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (521, 'Carmanova', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (522, 'Caterinovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (523, 'Cerniţa', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (524, 'Chirov', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (525, 'Cobasna', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (526, 'Coicova', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (527, 'Colosova', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (528, 'Comisarovca Nouă', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (529, 'Constantinovca (Camenca)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (530, 'Constantinovca (Slobozia)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (531, 'Corotna', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (532, 'Coşniţa Nouă', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (533, 'Cotovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (534, 'Crasnaia Besarabia', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (535, 'Crasnencoe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (536, 'Crasnîi Octeabri', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (537, 'Crasnîi Vinogradari', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (538, 'Crasnoe (Grigoriopol)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (539, 'Crasnogorca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (540, 'Cuzmin', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (541, 'Dimitrova', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (542, 'Doibani I', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (543, 'Doibani II', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (544, 'Dubău', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (545, 'Fedoseevca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (546, 'Frunză', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (547, 'Frunzăuca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (548, 'Gherşunovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (549, 'Goian', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (550, 'Goianul Nou', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (551, 'Haraba', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (552, 'Harmaţca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (553, 'Hîrtop', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (554, 'Hlinaia (Grigoriopol)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (555, 'Hlinaia (Slobozia)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (556, 'Hristovaia', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (557, 'Hruşca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (558, 'Iagorlîc', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (559, 'Iantarnoe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (560, 'Ivanovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (561, 'Jura', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (562, 'Lenin', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (563, 'Lîsaia Gora', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (564, 'Lunga Nouă', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (565, 'Marian', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (566, 'Mălăieşti', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (567, 'Mihailovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (568, 'Mihailovca Nouă', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (569, 'Mocearovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (570, 'Mocra', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (571, 'Mocreachi', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (572, 'Molochişul Mare', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (573, 'Molochişul Mic', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (574, 'Nezavertailovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (575, 'Nicolscoe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (576, 'Novaia Jizni', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (577, 'Novocotovsc', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (578, 'Novosaviţcaia (loc.st.cf)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (579, 'Novovladimirovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (580, 'Ocniţa', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (581, 'Parcani', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (582, 'Pervomaisc (Rîbnița)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (583, 'Pervomaisc (Slobozia)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (584, 'Pîcalova', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (585, 'Plopi', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (586, 'Pobeda (Grigoriopol)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (587, 'Pobeda (Rîbnița)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (588, 'Podoima', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (589, 'Podoimiţa', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (590, 'Pohrebea Nouă', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (591, 'Popencu', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (592, 'Prioziornoe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (593, 'Raşcov', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (594, 'Rotari', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (595, 'Sadchi', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (596, 'Severinovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (597, 'Slobozia-Raşcov', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (598, 'Socolovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (599, 'Solnecinoe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (600, 'Sovietscoe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (601, 'Stanislavca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (602, 'Stroieşti', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (603, 'Sucleia', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (604, 'Suhaia Rîbniţa', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (605, 'Şevcenco', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (606, 'Şipca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (607, 'Şmalena', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (608, 'Taşlîc', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (609, 'Ţîbuleuca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (610, 'Uiutnoe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (611, 'Ulmu', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (612, 'Ulmul Mic', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (613, 'Vadul Turcului', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (614, 'Valea Adîncă', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (615, 'Vasilievca (Dubăsari)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (616, 'Vasilievca (Rîbnița)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (617, 'Vărăncău', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (618, 'Vesioloe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (619, 'Vinogradnoe', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (620, 'Vladimirovca (Rîbnița)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (621, 'Vladimirovca (Slobozia)', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (622, 'Voitovca', 21);
INSERT INTO aba.locality (LocalityId, LocalityName, DistrictId) VALUES (623, 'Zaporojeţ', 21);

INSERT INTO aba.mconnect_validation (MconnectValidationId, RequestId, ValidationTypeId, ValidationValue) VALUES (1, 1, 1, 'Huliganism - 02.03.2015 - Privare de libertate pentru perioada de 2 ani. Pedeapsa ispasita.');
INSERT INTO aba.mconnect_validation (MconnectValidationId, RequestId, ValidationTypeId, ValidationValue) VALUES (2, 3, 3, 'Absent');
INSERT INTO aba.mconnect_validation (MconnectValidationId, RequestId, ValidationTypeId, ValidationValue) VALUES (3, 4, 4, 'Absent');
INSERT INTO aba.mconnect_validation (MconnectValidationId, RequestId, ValidationTypeId, ValidationValue) VALUES (4, 1, 1, 'Furt - 14.05.2018 - Privare de libertate pentru perioada de 1 ani. Pedeapsa ispasita.');
INSERT INTO aba.mconnect_validation (MconnectValidationId, RequestId, ValidationTypeId, ValidationValue) VALUES (5, 3, 1, 'Huliganism - 12.07.2018 - Privare de libertate pentru perioada de 1.5 ani. Pedeapsa ispasita.');

INSERT INTO aba.police_sector (PoliceSectorId, PoliceSectorName, RegionalDirectionId) VALUES (1, 'Sculeni', 4);

INSERT INTO aba.receiving_method (ReceivingMethodId, ReceivingMethodName, IsRequired) VALUES (1, 'SMS(Telefon)', 1);
INSERT INTO aba.receiving_method (ReceivingMethodId, ReceivingMethodName, IsRequired) VALUES (2, 'Poștă electronică', 0);

INSERT INTO aba.regional_direction (RegionalDirectionId, AreaId, RegionalDirectionName) VALUES (2, 1, 'NORD');
INSERT INTO aba.regional_direction (RegionalDirectionId, AreaId, RegionalDirectionName) VALUES (3, 2, 'SUD');
INSERT INTO aba.regional_direction (RegionalDirectionId, AreaId, RegionalDirectionName) VALUES (4, 3, 'VEST');
INSERT INTO aba.regional_direction (RegionalDirectionId, AreaId, RegionalDirectionName) VALUES (5, 4, 'EST');

INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (1, '2000000000000', 2, '2021-03-07', '2021-03-15', '2021-03-05', 2, null, 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (2, '2000000000000', 2, '2021-03-07', '2021-03-19', '2021-03-05', 2, null, 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (3, '2000000000000', 3, '2021-03-16', '2021-03-19', '2021-03-05', 3, 'Doar in apropierea padurilor', 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (4, '2000000000000', 4, '2021-03-14', '2021-03-15', '2021-03-05', 4, 'Doar in apropierea lacurilor', 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (5, '2000000000000', 2, '2021-03-08', '2021-03-09', '2021-03-05', 2, null, 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (6, '2000000000000', 2, '2021-03-07', '2021-03-08', '2021-03-05', 2, null, 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (7, '2000000000000', 2, '2021-03-14', '2021-03-15', '2021-03-05', 2, null, 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (8, '2000000000000', 4, '2021-04-14', '2021-04-29', '2021-04-08', 2, 'Doar in apropierea lacurilor', 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (9, '2000000000000', 3, '2021-04-21', '2021-04-22', '2021-04-08', 2, 'Doar in apropierea padurilor', 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (10, '2000000000000', 4, '2021-04-04', '2021-04-15', '2021-04-08', 2, 'Doar in apropierea lacurilor', 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (11, '2000000000000', 3, '2021-04-18', '2021-04-21', '2021-04-08', 2, 'Doar in apropierea padurilor', 0);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (12, '2000000000000', 4, '2021-04-19', '2021-04-22', '2021-04-08', 2, 'Doar in apropierea lacurilor', 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (13, '2000000000000', 3, '2021-04-11', '2021-04-21', '2021-04-10', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (14, '2000000000000', 2, '2021-04-06', '2021-04-15', '2021-04-10', 2, 'Ma void odihni pe marginea padurii', 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (15, '2000000000000', 2, '2021-04-18', '2021-04-21', '2021-04-10', 2, 'Ma voi odihni pe marginea lacului', 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (16, '2000000000000', 2, '2021-04-13', '2021-04-21', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (17, '2000000000000', 3, '2021-04-11', '2021-04-13', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (18, '2000000000000', 4, '2021-04-11', '2021-04-13', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (19, '2000000000000', 2, '2021-04-13', '2021-04-21', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (20, '2000000000000', 3, '2021-04-19', '2021-04-20', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (21, '2000000000000', 2, '2021-04-13', '2021-04-14', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (22, '2000000000000', 2, '2021-04-11', '2021-04-13', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (23, '2000000000000', 2, '2021-04-14', '2021-04-16', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (24, '2000000000000', 2, '2021-04-14', '2021-04-16', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (25, '2000000000000', 4, '2021-04-12', '2021-04-14', '2021-04-11', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (26, '2000000000000', 2, '2021-04-14', '2021-04-16', '2021-04-12', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (27, '2000000000000', 2, '2021-04-14', '2021-04-14', '2021-04-12', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (28, '2000000000000', 2, '2021-04-16', '2021-04-20', '2021-04-14', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (29, '2000000000000', 3, '2021-04-16', '2021-04-20', '2021-04-14', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (30, '2000000000000', 4, '2021-04-20', '2021-04-22', '2021-04-14', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (31, '2000000000000', 4, '2021-04-22', '2021-04-24', '2021-04-15', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (32, '2000000000000', 4, '2021-04-16', '2021-04-19', '2021-04-15', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (33, '2000000000000', 2, '2021-05-20', '2021-05-22', '2021-05-13', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (34, '2000000000000', 2, '2021-05-20', '2021-05-21', '2021-05-13', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (35, '2000000000000', 4, '2021-05-20', '2021-05-22', '2021-05-17', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (36, '2000000000000', 3, '2021-05-28', '2021-05-31', '2021-05-20', 1, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (37, '2000000000000', 2, '2021-06-10', '2021-06-11', '2021-06-08', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (38, '2000000000000', 2, '2021-06-10', '2021-06-11', '2021-06-08', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (39, '2000000000000', 2, '2021-06-11', '2021-06-12', '2021-06-09', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (40, '2000000000000', 2, '2021-06-10', '2021-06-10', '2021-06-09', 2, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (41, '2000000000000', 2, '2022-04-14', '2022-04-20', '2022-04-13', 1, null, 1);
INSERT INTO aba.request (RequestId, CitizenIDNP, ActivityId, StartDate, EndDate, CreatedAt, StatusId, Note, NotifyExpiry) VALUES (42, '2000000000000', 2, '2022-06-08', '2022-06-14', '2022-06-03', 1, null, 1);

INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (1, 1, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (2, 1, 171);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (3, 2, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (4, 2, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (5, 2, 429);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (6, 2, 430);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (7, 3, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (8, 3, 285);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (9, 3, 284);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (10, 3, 283);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (19, 3, 260);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (20, 3, 259);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (21, 3, 258);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (22, 3, 257);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (23, 3, 442);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (24, 3, 441);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (25, 3, 440);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (30, 3, 173);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (31, 3, 172);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (32, 3, 166);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (33, 3, 165);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (37, 3, 286);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (38, 3, 287);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (39, 4, 241);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (40, 4, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (41, 4, 257);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (42, 4, 258);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (43, 4, 275);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (44, 4, 276);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (45, 5, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (46, 5, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (47, 5, 170);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (48, 5, 171);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (49, 6, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (50, 6, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (51, 6, 170);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (52, 6, 171);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (53, 7, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (54, 7, 165);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (55, 7, 170);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (56, 7, 171);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (57, 8, 104);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (58, 8, 105);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (59, 8, 123);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (60, 8, 147);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (61, 8, 148);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (62, 9, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (63, 9, 179);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (64, 9, 180);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (65, 10, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (66, 11, 259);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (67, 11, 258);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (68, 12, 497);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (69, 12, 496);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (70, 13, 170);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (71, 14, 241);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (72, 14, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (73, 15, 110);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (74, 15, 111);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (75, 16, 333);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (76, 16, 334);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (77, 16, 335);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (78, 16, 336);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (79, 17, 429);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (80, 17, 430);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (81, 18, 340);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (82, 18, 339);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (83, 18, 341);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (84, 19, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (85, 19, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (86, 20, 430);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (87, 21, 241);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (88, 21, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (89, 22, 429);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (90, 23, 450);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (91, 23, 451);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (92, 23, 452);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (93, 24, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (94, 24, 165);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (95, 25, 270);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (96, 25, 272);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (97, 25, 278);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (98, 25, 286);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (99, 25, 288);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (100, 25, 294);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (101, 25, 293);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (102, 25, 292);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (103, 25, 374);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (104, 25, 375);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (105, 25, 381);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (106, 25, 382);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (107, 25, 389);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (108, 25, 391);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (109, 25, 397);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (110, 25, 396);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (111, 25, 271);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (112, 25, 399);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (113, 25, 400);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (114, 25, 263);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (115, 25, 275);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (116, 25, 277);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (117, 25, 167);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (118, 25, 168);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (119, 25, 174);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (120, 25, 176);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (121, 25, 264);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (122, 25, 187);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (123, 25, 185);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (124, 25, 241);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (125, 25, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (126, 25, 250);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (127, 25, 251);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (128, 25, 262);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (129, 25, 186);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (130, 26, 241);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (131, 26, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (132, 26, 257);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (133, 26, 258);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (134, 26, 104);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (135, 26, 105);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (136, 26, 109);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (137, 26, 110);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (138, 26, 111);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (139, 27, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (140, 27, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (141, 28, 332);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (142, 28, 333);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (143, 28, 334);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (144, 29, 339);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (145, 29, 340);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (146, 29, 341);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (147, 30, 332);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (148, 30, 336);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (149, 30, 337);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (150, 31, 336);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (151, 31, 337);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (152, 31, 338);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (153, 31, 241);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (154, 31, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (155, 31, 243);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (156, 32, 333);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (157, 32, 334);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (158, 32, 335);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (159, 33, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (160, 33, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (161, 33, 328);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (162, 33, 329);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (163, 34, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (164, 34, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (165, 34, 172);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (166, 34, 173);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (167, 35, 347);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (168, 35, 348);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (169, 36, 196);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (170, 36, 198);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (171, 36, 363);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (172, 36, 370);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (173, 37, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (174, 37, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (175, 37, 241);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (176, 37, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (177, 38, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (178, 38, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (179, 38, 193);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (180, 38, 192);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (181, 38, 241);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (182, 38, 242);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (183, 39, 341);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (184, 39, 342);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (185, 39, 343);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (186, 40, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (187, 40, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (188, 40, 170);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (189, 40, 171);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (190, 41, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (191, 41, 164);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (192, 41, 104);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (193, 41, 105);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (194, 42, 163);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (195, 42, 332);
INSERT INTO aba.request_locality (Id, RequestId, LocalityId) VALUES (196, 42, 333);

INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (1, 1, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (2, 2, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (3, 3, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (4, 4, 1, '67432156');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (5, 5, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (6, 6, 1, '75464565');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (7, 7, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (8, 8, 1, '12342342');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (9, 9, 1, '23421341');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (10, 10, 1, '12341234');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (11, 11, 1, '12341234');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (12, 12, 1, '21341234');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (13, 1, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (14, 2, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (15, 3, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (16, 13, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (17, 14, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (18, 15, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (19, 15, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (20, 16, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (21, 16, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (22, 17, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (23, 17, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (24, 18, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (25, 18, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (26, 19, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (27, 19, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (28, 20, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (29, 20, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (30, 21, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (31, 21, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (32, 22, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (33, 22, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (34, 23, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (35, 23, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (36, 24, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (37, 24, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (38, 25, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (39, 25, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (40, 26, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (41, 26, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (42, 27, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (43, 27, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (44, 28, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (45, 28, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (46, 29, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (47, 29, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (48, 30, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (49, 30, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (50, 31, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (51, 31, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (52, 32, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (53, 32, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (54, 33, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (55, 33, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (56, 34, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (57, 34, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (58, 35, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (59, 35, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (60, 36, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (61, 36, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (62, 37, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (63, 37, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (64, 38, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (65, 38, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (66, 39, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (67, 39, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (68, 40, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (69, 40, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (70, 41, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (71, 41, 2, 'dumitru12345@gmail.com');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (72, 42, 1, '79315262');
INSERT INTO aba.request_receiving_method (Id, RequestId, ReceivingMethodId, ReceivingMethodValue) VALUES (73, 42, 2, 'dumitru12345@gmail.com');

INSERT INTO aba.request_status (StatusId, StatusName) VALUES (1, 'În așteptare');
INSERT INTO aba.request_status (StatusId, StatusName) VALUES (2, 'Aprobat');
INSERT INTO aba.request_status (StatusId, StatusName) VALUES (3, 'Respins');
INSERT INTO aba.request_status (StatusId, StatusName) VALUES (4, 'Anulat');
INSERT INTO aba.request_status (StatusId, StatusName) VALUES (5, 'Expirat');

INSERT INTO aba.validation_type (ValidationTypeId, ValidationTypeName) VALUES (1, 'Antecedente penale');
INSERT INTO aba.validation_type (ValidationTypeId, ValidationTypeName) VALUES (2, 'Antecedente în zona de frontieră');
INSERT INTO aba.validation_type (ValidationTypeId, ValidationTypeName) VALUES (3, 'Permis de vânătoare');
INSERT INTO aba.validation_type (ValidationTypeId, ValidationTypeName) VALUES (4, 'Permis de pescuit');
