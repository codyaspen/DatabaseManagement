--Cody Eichelberger--
--November 26, 2014--
--Lab 10--
--Stored procedures--

--1.--

CREATE OR REPLACE FUNCTION PreReqsFor (IN coursenumber integer)
 RETURNS TABLE("Prerequisite Course Number" int, "Course Name" text) AS 
$BODY$
BEGIN
   RETURN QUERY SELECT prereqnum as prerequisites, courses.name as courseName
      			FROM  courses
      			INNER JOIN prerequisites
      			ON courses.num = prerequisites.courseNum
       			WHERE prerequisites.courseNum = courseNumber;
END;
$BODY$
LANGUAGE PLPGSQL;

--2.--

CREATE OR REPLACE FUNCTION IsPreReqFor(IN coursenumber integer)

 RETURNS TABLE("Successive Course Number" int, "Course Name" text) AS 
 $BODY$
BEGIN
   RETURN QUERY SELECT coursenum , courses.name 
      			FROM  courses
      			INNER JOIN prerequisites
      			ON courses.num = prerequisites.courseNum
       			WHERE prerequisites.preReqNum = courseNumber;
   
END;
$BODY$
LANGUAGE PLPGSQL;

