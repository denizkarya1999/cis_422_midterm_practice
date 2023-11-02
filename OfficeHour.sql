-- Create a table for universities and student associations --
CREATE TABLE UNIVERSITIES (
  UID INT PRIMARY KEY,
  UniversityName VARCHAR(100),
  Country VARCHAR(100)
);

-- These are ddl statements --
-- Create CS_STUDENTS Table --
CREATE TABLE CS_STUDENTS (
  SID INT PRIMARY KEY,
  Name VARCHAR(100),
  Major VARCHAR(2),
  GPA FLOAT(3),
  UID INT references Universities(UID)
);
-- Create CS_EVENTS Table --
CREATE TABLE CS_EVENTS (
  EID INT PRIMARY KEY,
  EventName VARCHAR(100),
  SeatsAvailable INT
);

create table attendance (
  SID INT references CS_STUDENTS(SID) NOT NULL,
  EID INT references CS_EVENTs(EID) NOT NULL,
  constraint pk primary key(sid,eid) 
);

insert into cs_events values (111, 'VLDB', 1000); 
insert into cs_events values (222, 'SIGMOD', 2000); 
insert into cs_events values (333, 'Artificial Intelligence and Plagiarism', 1500); 
insert into cs_events values (444, 'Computer Scientists: From Alan Turing to Tim-Berners Lee', 1200); 
insert into cs_events values (555, 'Future of Software Engineering after Generative AI', 1100);
insert into cs_events values (666, 'Detecting false information using AI on Social Media', 900);

insert into universities values (1, 'UM-Ann Arbor', 'US');
insert into universities values (2, 'UM-Dearborn', 'US');
insert into universities values (3, 'Harvard University', 'US');
insert into universities values (4, 'Massachusetts Institute of Technology', 'US');
insert into universities values (5, 'University of Cambridge', 'UK');
insert into universities values (6, 'Munich Technical University', 'Germany');
insert into universities values (7, 'University of Waterloo', 'Canada');

insert into cs_students values (1, 'Olmert', 'CS', 3.8, 1);
insert into cs_students values (2, 'Deniz', 'CS', 3.23, 2);
insert into cs_students values (3, 'Kejsiana', 'DS', 3.50, 2);
insert into cs_students values (4, 'Patel', 'CS', 3.90, 2);
insert into cs_students values (5, 'Diego', 'CS', 3.90, 3);
insert into cs_students values (6, 'David', 'CS', 3.87, 5);
insert into cs_students values (7, 'Wang', 'CS', 3.31, 4);
insert into cs_students values (8, 'Florian', 'DS', 3.51, 6);
insert into cs_students values (9, 'George', 'CS', 3.92, 7);
insert into cs_students values (10, 'Mohammad', 'CS', 3.01, 7);

insert into attendance values (2, 444);
insert into attendance values (1, 222);
insert into attendance values (1, 111);
insert into attendance values (6, 555);
insert into attendance values (2, 333);
insert into attendance values (2, 666);
insert into attendance values (3, 111);
insert into attendance values (5, 111);
insert into attendance values (7, 222);
insert into attendance values (8, 111);
insert into attendance values (9, 222);

-- Combine all of the tables --
CREATE VIEW CombinedTable AS
SELECT CS.SID, CS.Name AS StudentName, CS.Major, CS.GPA, U.UniversityName, U.Country, E.EventName
FROM CS_STUDENTS CS
JOIN UNIVERSITIES U ON CS.UID = U.UID
JOIN ATTENDANCE A ON CS.SID = A.SID
JOIN CS_EVENTS E ON A.EID = E.EID;

-- Select the student with highest grade --
Create view HighestGrade as 
SELECT CS.SID, CS.Name AS StudentName, CS.Major, CS.GPA, U.UniversityName, U.Country, E.EventName
FROM CS_STUDENTS as CS
JOIN UNIVERSITIES as U ON CS.UID = U.UID
JOIN ATTENDANCE A ON CS.SID = A.SID
JOIN CS_EVENTS as E ON A.EID = E.EID
WHERE CS.GPA = (SELECT MAX(GPA) FROM CS_STUDENTS);

-- Select students who study software engineering
create view v3 as 
SELECT *
FROM CS_STUDENTS
WHERE major = 'SE' OR major = 'CS'
ORDER BY GPA DESC;

-- Count the number of software engineering students --
create view no_software_engineers as
SELECT COUNT(*) as SE_Majors
FROM  CS_STUDENTS 
WHERE Major = 'SE';

-- Count the number of computer science students --
create view no_cs_students as
SELECT COUNT(*) as CS_Majors
FROM  CS_STUDENTS 
WHERE Major = 'CS';

-- Count all computer science, software engineering and data science students
create view total_students as
SELECT SUM(SE) AS ALL_TARGETS
FROM (SELECT * FROM (SELECT COUNT(*) as SE
FROM  CS_STUDENTS 
WHERE Major = 'SE') as g
UNION ALL
SELECT * FROM (SELECT COUNT(*) as CS_Majors
FROM  CS_STUDENTS 
WHERE Major = 'CS') as j
UNION ALL
SELECT * FROM (SELECT COUNT(*) as CS_Majors
FROM  CS_STUDENTS 
WHERE Major = 'DS') as m) as K;

-- Select total event capacity --
create view capacity as
SELECT SUM(seatsavailable) as TotalEventCapacity
FROM CS_STUDENTS CS
JOIN UNIVERSITIES U ON CS.UID = U.UID
JOIN ATTENDANCE A ON CS.SID = A.SID
JOIN CS_EVENTS E ON A.EID = E.EID;

SELECT * FROM COMBINEDTABLE;

SELECT * FROM HIGHESTGRADE;

SELECT *
FROM no_software_engineers;

SELECT *
FROM no_cs_students;

SELECT *
FROM total_students;

SELECT * 
FROM CAPACITY;