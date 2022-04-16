-- This script was generated by a beta version of the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public."Students"
(
    "StudentID" text NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "Pesel" text NOT NULL CONSTRAINT peselLength check ( length("Pesel") = 11 ),
    "Semester" smallint NOT NULL CONSTRAINT correctSemester check ( "Semester" > 0 AND "Semester" <= 10 ),
    PRIMARY KEY ("StudentID")
);

CREATE TABLE IF NOT EXISTS public."Lecturers"
(
    "LecturerID" smallserial NOT NULL,
    "FirstName" text NOT NULL,
    "LastName" text NOT NULL,
    "Degree" text NOT NULL CONSTRAINT correctDegree check ( "Degree" = ANY(ARRAY ['BA','MA','PhD','DCL','Mgr','Dr','Inz'])),
    PRIMARY KEY ("LecturerID")
);

CREATE TABLE IF NOT EXISTS public."Faculties"
(
    "FacultyID" smallserial NOT NULL,
    "Name" text NOT NULL UNIQUE,
    PRIMARY KEY ("FacultyID")
);

CREATE TABLE IF NOT EXISTS public."Courses"
(
    "CourseID" smallserial NOT NULL,
    "Name" text NOT NULL,
    "FacultyID" smallserial NOT NULL,
    "LecturerID" smallserial NOT NULL,
    "NumberOfPlaces" smallint NOT NULL CONSTRAINT positiveNOPlaces check ( "NumberOfPlaces" > 0 ),
    "ETCS" smallint NOT NULL CONSTRAINT correctECTS check ( "ETCS" > 0 AND "ETCS" < 10),
    "Description" text,
    "Semester" smallint NOT NULL CONSTRAINT correctSemester check ( "Semester" > 0 and "Semester" <= 10 ),
    PRIMARY KEY ("CourseID")
);

CREATE TABLE IF NOT EXISTS public."StudentsFaculties"
(
    "StudentID" text NOT NULL,
    "FacultyID" smallserial NOT NULL,
    PRIMARY KEY ("StudentID", "FacultyID")
);

CREATE TABLE IF NOT EXISTS public."StudentsCourses"
(
    "StudentID" text NOT NULL,
    "CourseID" smallserial NOT NULL,
    PRIMARY KEY ("StudentID", "CourseID")
);

CREATE TABLE IF NOT EXISTS public."CoursesHours"
(
    "CourseID" smallserial NOT NULL,
    "WeekDay" smallint NOT NULL check ( "WeekDay" < 5 ),
    "StartTime" time without time zone NOT NULL,
    "EndTime" time without time zone NOT NULL,
    PRIMARY KEY ("CourseID", "WeekDay", "StartTime")
);

ALTER TABLE IF EXISTS public."Courses"
    ADD CONSTRAINT "FacultyFK" FOREIGN KEY ("FacultyID")
    REFERENCES public."Faculties" ("FacultyID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."Courses"
    ADD CONSTRAINT "LecturerFK" FOREIGN KEY ("LecturerID")
    REFERENCES public."Lecturers" ("LecturerID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."StudentsFaculties"
    ADD FOREIGN KEY ("StudentID")
    REFERENCES public."Students" ("StudentID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."StudentsFaculties"
    ADD FOREIGN KEY ("FacultyID")
    REFERENCES public."Faculties" ("FacultyID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."StudentsCourses"
    ADD FOREIGN KEY ("StudentID")
    REFERENCES public."Students" ("StudentID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."StudentsCourses"
    ADD FOREIGN KEY ("CourseID")
    REFERENCES public."Courses" ("CourseID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."CoursesHours"
    ADD CONSTRAINT "CourseFK" FOREIGN KEY ("CourseID")
    REFERENCES public."Courses" ("CourseID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;

