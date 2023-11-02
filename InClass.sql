-- Create a table for universities and student associations --
CREATE TABLE UNIVERSITIES (
  UID INT PRIMARY KEY,
  UniversityName VARCHAR(100),
  Country VARCHAR(100)
);

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
insert into cs_students values (11, 'Zhiwei', 'CS', 4, 1);
insert into cs_students values (12, 'Takatu', 'CS', 0.1, 1);

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

CREATE VIEW V AS
SELECT 
  S.SID,
  S.NAME, 
  S.GPA,
  COUNT(DISTINCT EID) AS EVCOUNT 
FROM CS_STUDENTS AS S
LEFT JOIN ATTENDANCE AS A using(SID)
LEFT JOIN CS_EVENTS AS E using(EID)
GROUP BY s.sid, S.NAME, s.GPA;

SELECT *
FROM V AS V1
WHERE NOT EXISTS
(
  SELECT V2.SID
  FROM V AS V2
  WHERE ((V2.EVCOUNT >= V1.EVCOUNT) AND (V2.GPA > V1.GPA))
  OR ((V2.EVCOUNT>V1.EVCOUNT) AND (V2.GPA>=V1.GPA))
);