-- Cody Eichelberger --
-- December 4th, 2014 --
-- Database Design Project --

-- Create Statements --

-- States -- 
CREATE TABLE states (
  zipCode        integer not null unique,
  city           text not null,
  state          text not null,
 primary key(zipCode)
);

-- Prison Areas -- 
CREATE TABLE prisonAreas (
  areaId         char(3) not null unique,
  areaName       text, 
 primary key(areaId) 
);

-- Cells -- 
CREATE TABLE cells (
  cellId         integer not null unique CHECK (0 < cellId AND cellId < 26),
  cellBlock      char(1) not null CHECK (cellBlock = 'a' 
                                         OR cellBlock = 'b' 
                                         OR cellBlock = 'c'
                                        ),
 primary key(cellId)
);

-- People -- 
CREATE TABLE people (
  pid            char(4) not null unique,
  firstName      text not null,
  lastName       text not null,
  streetAddress  text not null,
  dateOfBirth    date not null,
  zipCode        integer not null,
 primary key(pid),
 foreign key(zipCode) references states(zipCode)
);

-- Infirmary Visits -- 
CREATE TABLE infirmaryVisits (
  timeAdmitted   timestamp not null unique,
  pid            char(4) not null unique,
  diagnosis      text not null,
 primary key(timeAdmitted),
 foreign key(pid) references people(pid)
);

-- Staff -- 
CREATE TABLE staff (
  sid            char(4) not null unique references people(pid),
  dateHired      date not null,
  dateReleased   date,
 primary key(sid)
);

-- Guards -- 
CREATE TABLE guards (
  gid            char(4) not null unique references people(pid),
  dateHired      date not null,
  dateReleased   date,
  salaryUSD      numeric not null,
  areaId         char(3) not null unique references prisonAreas(areaId),
 primary key(gid),
 foreign key(areaId) references prisonAreas(areaId)
);

-- Prisoners -- 
CREATE TABLE prisoners (
  prid           char(4) not null unique references people(pid),
  heightInches   integer not null,
  weightLbs      integer not null,
  hairColor      text,
  cellId         integer not null unique references cells(cellId),
 primary key(prid),
 foreign key(cellId) references cells(cellId)
);

-- Visitors -- 
CREATE TABLE visitors (
  vid            char(4) not null unique references people(pid),
 primary key(vid)
);

-- Prisoner Employees -- 
CREATE TABLE prisonerEmployees (
  prid           char(4) not null unique references prisoners(prid),
  areaId         char(3) references prisonAreas(areaId),
 primary key(prid),
 foreign key(prid) references prisoners(prid),
 foreign key(areaId) references prisonAreas(areaId)
);

-- Positions -- 
CREATE TABLE positions (
  positionId     char(4) not null unique,
  positionTitle  text,
  salaryUSD      numeric,
  areaId         char(3) not null references prisonAreas(areaId),
  sid            char(4) not null unique references staff(sid),    
 primary key(positionId), 
 foreign key(areaId) references prisonAreas(areaId),
 foreign key(sid) references staff(sid)
);

-- Case Files -- 
CREATE TABLE caseFiles (
  caseId               char(5) not null unique,
  incarcerationDate    date not null,
  dateReleased         date,
  sentenceLengthYears  integer not null CHECK (sentenceLengthYears > 0),
  isViolentOffense     boolean not null,
  offense              text not null,
  prid                 char(4) not null references prisoners(prid),            
 primary key(caseId),
 foreign key(prid) references prisoners(prid) 
);

-- Visits -- 
CREATE TABLE visits (
  vid         char(4) not null references visitors(vid),
  visitTime   timestamp not null unique,
  prid        char(4) not null references prisoners(prid),
 primary key(vid, visitTime),
 foreign key(vid) references visitors(vid),
 foreign key(prid) references prisoners(prid) 
);

-- Infraction Types -- 
CREATE TABLE infractionTypes (
  infractionId   char(3) not null unique,
  infractionName text not null,
  penalty        text, 
 primary key(infractionId) 
);

-- Committed Infractions -- 
CREATE TABLE committedInfractions (
  incidentTime   timestamp not null unique,
  infractionId   char(3) not null references infractionTypes(infractionId),
  prid           char(4) not null references prisoners(prid), 
 primary key(incidentTime),
 foreign key(prid) references prisoners(prid) 
);

-- Insert Statements --

-- Cells -- 
INSERT INTO cells ( cellId, cellBlock )
  VALUES ( 1, 'a' ),
         ( 2, 'a' ),
         ( 3, 'a' ),
         ( 4, 'a' ),
         ( 5, 'a' ),
         ( 6, 'a' ),
         ( 7, 'a' ),
         ( 8, 'b' ),
         ( 9, 'b' ),
         ( 10, 'b' ),
         ( 11, 'b' ),
         ( 12, 'b' ),
         ( 13, 'b' ),
         ( 14, 'c' ),
         ( 15, 'c' ),
         ( 16, 'c' ),
         ( 17, 'c' ),
         ( 18, 'c' );
         
-- Prison Areas -- 
INSERT INTO prisonAreas ( areaId, areaName )
  VALUES ( 'a01', 'Administration Offices' ),
         ( 'a02', 'Cell Blocks' ),
         ( 'a03', 'Infirmary' ),
         ( 'a04', 'Kitchen' ),
         ( 'a05', 'Cafeteria' ),
         ( 'a06', 'East Yard' ),
         ( 'a07', 'West Yard' ),
         ( 'a08', 'Library' ),
         ( 'a09', 'Showers' ),
         ( 'a10', 'Commissary' ),
         ( 'a11', 'East Tower' ),
         ( 'a12', 'West Tower' ),
         ( 'a13', 'Laundry' );
         
-- States -- 
INSERT INTO states ( zipCode, city, state )
  VALUES ( 12601, 'Poughkeepsie', 'New York'),
         ( 33952, 'Port Charlotte', 'Florida'),
         ( 90052, 'Los Angeles', 'California'),
         ( 94612, 'Oakland', 'California'),
         ( 60607, 'Chicago', 'Illinois'),
         ( 70113, 'New Orleans', 'Louisiana'),
         ( 48223, 'Detroit', 'Michigan'),
         ( 10199, 'New York', 'New York'),
         ( 38101, 'Memphis', 'Tennessee'),
         ( 77201, 'Houston', 'Texas');
         
-- People -- 
INSERT INTO people ( pid, firstName, lastName, dateOfBirth, streetAddress, zipCode )
  VALUES 
         --Prisoners --
         ( 'p001', 'Joseph', 'Stalin', '1/5/1960', '101 Commie Way', 10199),
         ( 'p002', 'Ted', 'Bundy', '2/6/1975', '3 Heads Street', 48223),
         ( 'p003', 'Charles', 'Manson', '9/15/1964', '21 Cult Lane', 94612),
         ( 'p004', 'Bernie', 'Madoff', '4/13/1954', '404 Ponzi Street', 10199),
         ( 'p005', 'Al', 'Capone', '10/21/1988', '1 Gangster Circle', 10199 ),
         ( 'p006', 'Ted', 'Kaczynski', '7/10/1991', '90 Unabomb Terrace', 90052 ),
         ( 'p007', 'Adam', 'Lanza', '6/23/1989', '12 Washington Avenue', 60607),
         ( 'p008', 'Andrea', 'Kehoe', '11/10/1971', '68 Bath Street', 10199),
         ( 'p009', 'John', 'Gacy', '12/10/1994', '200 Newsome road', 60607),
         ( 'p010', 'timothy', 'McVeigh', '8/28/1988', '123 Fake Street', 70113),
         ( 'p011', 'Jim', 'jones', '4/13/1947', '399 Jones Way', 38101),
         ( 'p012', 'Scott', 'Peterson', '5/5/1983', '22 Grey Avenue', 33952),
         ( 'p013', 'James', 'Ray', '7/9/1970', '708 Mystery Street', 38101),
         ( 'p014', 'Jack', 'Kevorkian', '4/13/1990', '44567 Assisted Street', 90052),
         ( 'p015', 'Jeffrey', 'Dahmer', '4/13/1992', '666 God Lane' , 10199),
         -- staff --
         ( 'p016', 'Adam', 'Jones', '3/9/1980', '45 Exeter Street', 10199),
         ( 'p017', 'Cody', 'Eichelberger', '3/4/1993', '22227 Hernando Avenue', 33952),
         ( 'p018', 'Travis', 'Crabtree', '5/21/1992', '44332 Conway Avenue', 33952),
         ( 'p019', 'Jordon', 'Aroyo', '4/24/1994', '914 Alpine Ave', 33952),
         ( 'p020', 'Alan', 'Labouseur', '9/16/1995', '94 Postgres Lane', 60607),
         --guards--
         ( 'p021', 'Bobby', 'Hill', '2/4/1992', '5 Arlington Street', 77201),
         ( 'p022', 'Hank', 'Hill', '1/5/1975', '55 Propane Circle', 77201),
         ( 'p023', 'Big', 'Bird', '6/11/1982', '543 Almost Drive', 10199),
         ( 'p024', 'Toucan', 'Sam', '10/20/1985', '120 Sugar Lane', 38101),
         ( 'p025', 'Tickle', 'Elmo', '3/12/1978', '11 Sesame Street', 90052),
         --visitors--
         ( 'p026', 'Alex', 'Davis', '12/9/1991', '22 Gatsby Lane', 12601),
         ( 'p027', 'Buddy', 'Holly', '11/5/1976', '501 No Drive', 60607),
         ( 'p028', 'Joan', 'Arc', '8/1/1986', '98 Alamo Drive', 10199),
         ( 'p029', 'Mickey', 'Mouse', '10/24/1985', '10101 Doomed Lane', 33952),
         ( 'p030', 'Sir', 'Mixalot', '7/30/1988', '709 Booty Street', 48223);
         
-- Staff -- 
INSERT INTO staff ( sid, dateHired, dateReleased )
  VALUES ( 'p016', '1/14/2013', null ),
         ( 'p017', '3/20/2014', null ),
         ( 'p018', '6/19/2012', null ),
         ( 'p019', '7/4/2014', null ),
         ( 'p020', '4/21/2014', null );

-- Positions -- 
INSERT INTO positions ( positionId, positionTitle, salaryUSD, areaId, sid )
  VALUES ( 'r001', 'Warden', 120000, 'a01', 'p020' ),
         ( 'r002', 'Head Doctor', 70000, 'a03', 'p019' ),
         ( 'r003', 'Head Chef', 60000, 'a04', 'p018' ),
         ( 'r004', 'Commissary Manager', 30000, 'a10', 'p017' ),
         ( 'r005', 'Laundry Manager', 40000, 'a13', 'p016' );

         
-- Guards -- 
INSERT INTO guards ( gid, dateHired, dateReleased, salaryUSD, areaId )
  VALUES ( 'p021', '1/13/2013', null, 30000, 'a01' ),
         ( 'p022', '3/11/2009', null, 41000, 'a03' ),
         ( 'p023', '6/19/2010', null, 40000, 'a05' ),
         ( 'p024', '7/4/2014', null, 25000,  'a06' ),
         ( 'p025', '4/21/2000', null, 50000, 'a07' );

-- Prisoners --
INSERT INTO prisoners ( prid, heightInches, weightLbs, hairColor, cellId )
  VALUES ( 'p001', 67, 130, 'brown', 1 ),
         ( 'p002', 65, 120, 'black', 2 ),
         ( 'p003', 70, 144, 'brown', 4 ),
         ( 'p004', 68, 188, 'blonde', 5 ),
         ( 'p005', 67, 133, 'brown', 7 ),
         ( 'p006', 66, 156, 'red', 8 ),
         ( 'p007', 69, 175, 'blonde', 9 ),
         ( 'p008', 63, 129, 'black', 10 ),
         ( 'p009', 66, 150, 'black', 11 ),
         ( 'p010', 78, 175, 'brown', 17),
         ( 'p011', 67, 166, 'brown', 12 ),
         ( 'p012', 59, 162, 'brown', 13 ),
         ( 'p013', 73, 143, 'blonde', 14 ),
         ( 'p014', 75, 190, 'black', 15 ),
         ( 'p015', 69, 201, 'red', 16 );

-- Case Files -- 
INSERT INTO caseFiles ( caseId, incarcerationDate, dateReleased, 
                        sentenceLengthYears, isViolentOffense, 
                        offense, prid )
  VALUES ( 'c001', '1/8/1999', null, 20, true, 'murdered wife', 'p001' ),
         ( 'c002', '10/12/1994', null, 25, true, 'murdered neighbor', 'p002' ),
         ( 'c003', '5/14/1985', null, 45, true, 'rape', 'p003' ),
         ( 'c004', '7/2/2002', null, 15, true, 'armed robbery', 'p004' ),
         ( 'c005', '2/3/2005', null, 10, false, 'drug trafficking', 'p005' ),
         ( 'c006', '8/5/2013', null, 10, false, 'piracy', 'p006' ),
         ( 'c007', '11/9/2011', null, 5, false, 'grand theft', 'p007' ),
         ( 'c008', '12/11/1992', null, 20, true, 'murder', 'p008' ),
         ( 'c009', '3/13/2014', null, 8, false, 'conspiracy to commit murder', 'p009' ),
         ( 'c010', '5/15/2012', null, 15, false, 'drug manufacture', 'p010' ),
         ( 'c011', '7/16/1980', null, 150, true, 'murdered village', 'p011' ),
         ( 'c012', '7/22/2003', null, 12, false, 'tax evasion', 'p012' ),
         ( 'c013', '4/28/2010', null, 7, true, 'manslaughter', 'p013' ),
         ( 'c014', '3/29/2011', null, 4, false, 'hacking', 'p014' ),
         ( 'c015', '1/14/2013', null, 2, true, 'assault', 'p015' );
        
  

-- Prisoner Employees --
INSERT INTO prisonerEmployees ( prid, areaId )
  VALUES ( 'p003', 'a04' ),
         ( 'p004', 'a04' ),
         ( 'p005', 'a05' ),
         ( 'p008', 'a08' ),
         ( 'p010', 'a13' );
       
-- Visitors -- 
INSERT INTO visitors ( vid )
  VALUES ( 'p026' ),
         ( 'p027' ),
         ( 'p028' ),
         ( 'p029' ),
         ( 'p030' );
  
-- Visits -- 
INSERT INTO visits ( vid, visitTime, prid )
  VALUES ( 'p026', '2013-05-08 09:30:00', 'p002' ),
         ( 'p026', '2013-06-08 09:32:00', 'p002' ),
         ( 'p026', '2013-07-08 09:45:00', 'p002' ),
         ( 'p026', '2013-08-08 10:38:00', 'p002' ),
         ( 'p028', '2010-04-18 14:30:00', 'p005' ),
         ( 'p030', '2012-11-28 13:12:00', 'p004' ),
         ( 'p027', '2014-10-13 11:34:00', 'p006' ),
         ( 'p027', '2014-10-15 11:45:00', 'p006' ),
         ( 'p027', '2014-10-16 10:51:00', 'p006' ),
         ( 'p029', '2009-01-20 15:38:00', 'p011' );

-- Infirmary Visits --
INSERT INTO infirmaryVisits ( timeAdmitted, pid, diagnosis )
  VALUES ( '2013-08-08 09:30:00', 'p001', 'herpes' ),
         ( '2014-09-04 11:30:00', 'p018', 'cut' ),
         ( '2012-04-12 12:30:00', 'p002', 'measles' ),
         ( '2011-05-10 21:30:00', 'p015', 'bruising' ),
         ( '2013-06-09 08:30:00', 'p024', 'fever' );
  

-- Infraction Types --
INSERT INTO infractionTypes ( infractionId, infractionName, penalty )
  VALUES ( 'i01', 'Attempted escape', 'One week of solitary confinement' ),
         ( 'i02', 'Assault on a guard or staff', 'Two weeks of solitary confinement' ),
         ( 'i03', 'Assault on fellow inmate', 'Two weeks of solitary confinement' ),
         ( 'i04', 'General insubordination', 'Revoke yard and commissary privileges' ),
         ( 'i05', 'Inciting a riot', 
                'Two days of solitary and no yard privileges for three weeks' ),
         ( 'i06', 'murder', 'Transfer to maximum security facility' ),
         ( 'i07', 'possession of contraband', 'One week of no yard privileges' );

-- Committed Infractions -- 
INSERT INTO committedInfractions ( incidentTime, prid, infractionId )
  VALUES ( '2010-04-18 12:34:00', 'p001', 'i01' ),
         ( '2011-05-28 14:20:00', 'p003', 'i02' ),
         ( '2011-11-11 14:50:00', 'p008', 'i03' ),
         ( '2009-02-20 14:17:00', 'p011', 'i04' ),
         ( '2013-03-14 14:31:00', 'p001', 'i01' ),
         ( '2007-09-19 14:23:00', 'p001', 'i07' ),
         ( '2008-07-01 14:47:00', 'p001', 'i05' ),
         ( '2009-05-27 14:35:00', 'p014', 'i07' ),
         ( '2013-01-13 14:03:00', 'p004', 'i07' ),
         ( '2012-06-18 14:51:00', 'p001', 'i04' );



-- interesting queries/reports --

-- 1. --
-- percentage of prison pop that is nonviolent--
SELECT TRUNC (
          CAST(
               ( SELECT COUNT(pid) AS nonViolentCount
                 FROM people
                 INNER JOIN prisoners
                 ON people.pid = prisoners.prid
                 INNER JOIN caseFiles
                 ON prisoners.prid = caseFiles.prid
                 WHERE isViolentOffense = false
               ) as decimal(5,2)
              )    
                 /
                 ( SELECT COUNT(prid) AS wholePopulation
                   FROM prisoners
                 )
       * 100
             ) as Percent_Nonviolent
       
-- 2. --
--percentage of pop that is under 25--
SELECT TRUNC (
          CAST(
               ( SELECT COUNT(pid) AS under25Count
                 FROM people
                 INNER JOIN prisoners
                 ON people.pid = prisoners.prid
                 WHERE date_part('year',age(dateOfBirth)) < 25
                 
               ) as decimal(5,2)
              )    
                 /
                 ( SELECT COUNT(prid) AS wholePopulation
                   FROM prisoners
                 )
       * 100
             ) as Percent_Under25

-- 3. --
--percentage of violent offenders with no prison infractions
SELECT TRUNC (
          CAST(
               ( SELECT COUNT(pid) AS peacefulViolent
                 FROM people
                 INNER JOIN prisoners
                 ON people.pid = prisoners.prid
                 INNER JOIN caseFiles
                 ON prisoners.prid = caseFiles.prid
                 LEFT OUTER JOIN committedInfractions
                 ON casefiles.prid = committedinfractions.prid
                 WHERE committedInfractions.prid IS NULL AND caseFiles.isViolentOffense = true
               ) as decimal(5,2)
              )    
                 /
                 ( 
                  SELECT COUNT(prisoners.prid) AS violentOffenders
                  FROM prisoners
                  INNER JOIN caseFiles
                  ON prisoners.prid = caseFiles.prid
                  WHERE isViolentOffense = true
                 )
       * 100
             ) as Percent_Peaceful_Violent_Prisoners
              
-- Views --

-- 1. --
CREATE VIEW PrisonPopulation AS
  SELECT firstName, lastName, prisoners.cellId as cellNumber, cellBlock as cellBlockLetter
  FROM people
  INNER JOIN prisoners
  ON people.pid = prisoners.prid
  INNER JOIN cells
  ON prisoners.cellId = cells.cellId
  ORDER BY lastName;

-- 2. --
CREATE VIEW CurrentStaff AS
  SELECT positionTitle as position, firstName, lastName, dateReleased 
  FROM people
  INNER JOIN staff
  ON people.pid = staff.sid
  INNER JOIN positions
  ON staff.sid = positions.sid
  WHERE dateReleased is null
  ORDER BY position DESC;
  
-- 3.--
CREATE VIEW guardAreas AS
  SELECT firstName, lastName, areaName as Area
  FROM people
  INNER JOIN guards
  ON people.pid = guards.gid
  INNER JOIN prisonAreas
  ON guards.areaId = prisonAreas.areaId
  ORDER BY lastName;

-- Stored Procedures --

--1.--
--insert prisoner to prisoner employee table --
CREATE OR REPLACE FUNCTION add_prisonerEmployee() RETURNS trigger AS
$BODY$
    BEGIN
        IF NEW.isViolentOffense = false THEN
            INSERT INTO prisonerEmployees (prid) VALUES (NEW.prid); 
        END IF;
        RETURN NEW;
    END;
 $BODY$   
 LANGUAGE plpgsql;
 
--2.--
--see what visitors a particular prisoner has--
CREATE OR REPLACE FUNCTION prisonerVisitors (IN prisonerId varchar(4))
 RETURNS TABLE("First Name" text, "LastName" text) AS 
$BODY$
BEGIN
   RETURN QUERY SELECT DISTINCT people.firstName as first_name, people.lastname as last_name
      			FROM  people
      			INNER JOIN visitors
      			ON people.pid = visitors.vid
      			INNER JOIN visits
      			ON visits.vid = visitors.vid
       			WHERE visits.prid = prisonerId;
END;
$BODY$
LANGUAGE PLPGSQL;

--3.--
--calculates and inserts the releaseDate based on sentence length--
CREATE OR REPLACE FUNCTION add_releaseDate() RETURNS TRIGGER AS
$BODY$
  DECLARE
    sentenceLength integer :=  365 * CAST (new.sentenceLengthYears as INTEGER);
    calcDateReleased TIMESTAMP := new.incarcerationDate + sentenceLength;
    BEGIN

    
         IF NEW.dateReleased IS NULL THEN
            UPDATE caseFiles
            SET dateReleased = calcDateReleased
            WHERE new.prid = prid ;
        END IF;
        RETURN NEW;
    END;
 $BODY$   
 LANGUAGE plpgsql;
 
 --4.--
 --Calculates Prisoner Age--
 CREATE OR REPLACE FUNCTION prisonerAge ( prisonerId varchar(4))
 RETURNS INTERVAL AS 
$BODY$
 DECLARE
   birthday date := (SELECT people.dateOfBirth 
                     FROM people
                     INNER JOIN prisoners
                     ON people.pid = prisoners.prid
                     WHERE prisoners.prid = prisonerId
                    );
BEGIN
   RETURN age(birthday);
END;
$BODY$
LANGUAGE PLPGSQL;

-- Triggers --
-- 1. --
-- when an entry in casefiles is inserted the prid is inserted into the --
-- prisonerEmployees table if isviolentOffense = false --
CREATE TRIGGER add_prisonerEmployee 
AFTER INSERT ON caseFiles 
FOR EACH ROW 
EXECUTE PROCEDURE add_prisonerEmployee();

--2.--
--when a prisoner is added, the release date is automatically filled in if it's null-- 
CREATE TRIGGER add_releaseDate
AFTER INSERT ON caseFiles
FOR EACH ROW
EXECUTE PROCEDURE add_releaseDate();

-- Security --
CREATE ROLE admin;
GRANT ALL ON ALL TABLES
IN SCHEMA PUBLIC
TO admin;

CREATE ROLE staff;
GRANT SELECT ON prisoners, cells,
                committedInfractions, infractionTypes,
                visitors, visits, prisonAreas,
                prisonerEmployees, staff, people,
                caseFiles, states, guards
TO staff;
GRANT INSERT ON people, staff,
                guards, infirmaryVisits,
                states, caseFiles
TO staff;
GRANT UPDATE ON prisonerEmployees, people, guards, staff, positions

CREATE ROLE guards;
GRANT SELECT ON prisoners, cells,
                committedInfractions, infractionTypes,
                visitors, visits, prisonAreas,
                prisonerEmployees, staff, people,
                caseFiles, states, guards
TO guards;
GRANT INSERT, UPDATE ON people, prisoners,
                committedInfractions, visitors,
                visits, states, prisonerEmployees
TO guards;
                 














