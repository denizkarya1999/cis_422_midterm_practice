-- These are ddl statements --
-- Create CS_STUDENTS Table --
CREATE TABLE CS_STUDENTS (
  SID INT PRIMARY KEY,
  Name VARCHAR(25),
  Major VARCHAR(2),
  Grade FLOAT(3) 
);
-- Create CS_EVENTS Table --
CREATE TABLE CS_EVENTS (
  EID INT PRIMARY KEY,
  AttendeeID INT REFERENCES CS_STUDENTS(SID),
  EventName VARCHAR(50),
  SeatsAvailable INT
);

-- Create a table for universities and student associations --
CREATE TABLE UNIVERSITIES (
  UID INT,
  SID INT REFERENCES CS_STUDENTS(SID) PRIMARY KEY,
  UniversityName VARCHAR(50),
  Country VARCHAR(50)
);


-- These are dml statements --
-- Populate CS_STUDENTS --
INSERT INTO CS_STUDENTS(sid, name, major, grade) VALUES (1, 'Deniz', 'CS', 3.23); 
INSERT INTO CS_STUDENTS(sid, name, major, grade) VALUES (2, 'Kejsi', 'DS', 3.90);
INSERT INTO CS_STUDENTS(sid, name, major, grade) VALUES (3, 'Micheal', 'ME', 4); 
INSERT INTO CS_STUDENTS(sid, name, major, grade) VALUES (4, 'George', 'CE', 3.10);
INSERT INTO CS_STUDENTS(sid, name, major, grade) VALUES (5, 'Tao', 'SE', 3.15); 
INSERT INTO CS_STUDENTS(sid, name, major, grade) VALUES (6, 'Patel', 'SE', 3.53);

-- Populate CS_EVENTS --
INSERT INTO CS_EVENTS(eid, attendeeID, eventName, SeatsAvailable) VALUES (1, 2, 'Woman in Data Science', 15);
INSERT INTO CS_EVENTS(eid, attendeeID, eventName, SeatsAvailable) VALUES (2, 1, 'Data Science for Political Campaigns', 45);
INSERT INTO CS_EVENTS(eid, attendeeID, eventName, SeatsAvailable) VALUES (3, 5, 'Impact of AI on China-US Relations', 10);
INSERT INTO CS_EVENTS(eid, attendeeID, eventName, SeatsAvailable) VALUES (4, 6, 'Impact of AI on Data Analysis', 50);
INSERT INTO CS_EVENTS(eid, attendeeID, eventName, SeatsAvailable) VALUES (5, 3, 'Use of Data Science in Game Development', 48);
INSERT INTO CS_EVENTS(eid, attendeeID, eventName, SeatsAvailable) VALUES (6, 4, 'Use of Data Science in US-Mexico Border Crossings', 5);
INSERT INTO CS_EVENTS(eid, attendeeID, eventName, SeatsAvailable) VALUES (7, 5, 'Data Science for Political Campaigns', 44);

-- Populate Universities --
INSERT INTO UNIVERSITIES(uid, sid, UniversityName, country) VALUES (1, 1, 'University of Michigan-Dearborn', 'United States of America');
INSERT INTO UNIVERSITIES(uid, sid, UniversityName, country) VALUES (1, 2, 'University of Michigan-Dearborn', 'United States of America');
INSERT INTO UNIVERSITIES(uid, sid, UniversityName, country) VALUES (2, 3, 'University of Michigan-Ann Arbor', 'United States of America');
INSERT INTO UNIVERSITIES(uid, sid, UniversityName, country) VALUES (2, 4, 'University of Michigan-Ann Arbor', 'United States of America');
INSERT INTO UNIVERSITIES(uid, sid, UniversityName, country) VALUES (2, 5, 'Tsinghua University', 'China');
INSERT INTO UNIVERSITIES(uid, sid, UniversityName, country) VALUES (2, 6, 'Indian Institute of Science', 'India');

-- Select all tables --
Create view TotalView as
SELECT U.SID, U.Name, U.Major, U.Grade, K.EID, K.EventName, K.SeatsAvailable, U.UID, U.UniversityName, U.Country
FROM (SELECT S.SID, S.Name, S.Major, S.Grade, U.UID, U.UniversityName, U.Country
      FROM CS_STUDENTS AS S
      INNER JOIN UNIVERSITIES AS U ON S.SID = U.SID) AS U
INNER JOIN (SELECT S.SID, S.Name, S.Major, S.Grade, E.EID, E.EventName, E.SeatsAvailable
            FROM CS_STUDENTS AS S
            INNER JOIN CS_EVENTS AS E ON S.SID = E.AttendeeID
            ORDER BY S.Grade DESC) AS K
ON U.SID = K.SID;

-- Select all students --
create view students as
SELECT *
FROM CS_STUDENTS;

-- Select all EVENTS --
create view events as
SELECT *
FROM CS_EVENTS;

-- Combination of the table -- 
create view v1 as 
SELECT *
FROM CS_STUDENTS as S, CS_EVENTS as E
WHERE S.SID = E.ATTENDEEID
ORDER BY S.GRADE DESC;

-- Select the student with the highest grade --
create view v2 as 
SELECT SID, NAME, MAJOR, GRADE
FROM V1
WHERE GRADE = (SELECT MAX(GRADE) FROM v1);

-- Select students who study software engineering
create view v3 as 
SELECT *
FROM CS_STUDENTS
WHERE major = 'SE' OR major = 'CS'
ORDER BY GRADE DESC;

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

-- Count the capacity of the event
create view capacity as
SELECT SUM(seatsavailable) as EventCapacity
FROM V1;

SELECT *
FROM TotalView;

SELECT *
FROM V1;

SELECT *
FROM V2;

SELECT *
FROM V3;

SELECT *
FROM no_software_engineers;

SELECT *
FROM no_cs_students;

SELECT *
FROM total_students;

SELECT *
FROM CAPACITY;